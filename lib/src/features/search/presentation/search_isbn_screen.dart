import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/search/data/search_repository.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';

class SearchScannerScreen extends ConsumerStatefulWidget {
  const SearchScannerScreen({super.key});

  @override
  ConsumerState<SearchScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<SearchScannerScreen> with WidgetsBindingObserver {
  late final MobileScannerController _cameraController;
  bool _isProcessing = false;
  String? _lastScannedCode;
  int _consecutiveDetections = 0;

  @override
  void initState() {
    super.initState();
    // 1. Escuchar los eventos del ciclo de vida del sistema operativo/Flutter
    WidgetsBinding.instance.addObserver(this);
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
    );
  }

  // 2. Liberar la cámara nativa si la app se pausa o recarga
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _cameraController.stop();
        break;
      case AppLifecycleState.resumed:
        _cameraController.start();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _checkDuplicateIsbn(BookSearchDto book) async {
    final isbn = book.isbn;
    final checkDuplicateIsbn = ref.read(checkDuplicateIsbnProvider);
    final existingBook = await checkDuplicateIsbn(isbn);

    if (!mounted) return;
    if (existingBook != null) {

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.duplicateBookTitle),
            content: Text(context.l10n.duplicateBookMessage),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Future.delayed(Duration.zero);

                  if (!context.mounted) return;
                  context.pushReplacement('/book_detail', extra: existingBook);
                },
                child: Text(context.l10n.accept),
              ),
            ],
          );
        },
      );
      return;
    }
    context.push('/search_detail', extra: book);
  }

  Future<void> _handleBarcodeDetected(String rawIsbn) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      ref.read(searchQueryProvider.notifier).submitQuery(rawIsbn);
      final books = await ref.read(searchBooksProvider.future);

      if (!mounted) return;

      if (books.isNotEmpty) {
        _checkDuplicateIsbn(books.first);
      } else {
        _navigateToSearchFallback(rawIsbn);
      }
    } catch (_) {
      if (!mounted) return;
       _navigateToSearchFallback(rawIsbn);
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _navigateToSearchFallback(String query) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.bookNotFoundTitle),
        content: Text(context.l10n.searchByNamePrompt),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              if (!context.mounted) return;
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              context.pushReplacement('/search');
            },
            child: Text(context.l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    context.push('/search', extra: query);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scanAreaWidth = screenSize.width * 0.75;
    final scanAreaHeight = scanAreaWidth * 0.6;

    final scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: scanAreaWidth,
      height: scanAreaHeight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildTitle(),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            scanWindow: scanWindow,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.cameraAccessError,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _cameraController.start(),
                      child: Text(context.l10n.retry),
                    ),
                  ],
                ),
              );
            },
            overlayBuilder: (context, constraints) {
              return _buildScannerOverlay(constraints);
            },
            onDetect: (capture) {
              if (_isProcessing) return;
              final barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final rawValue = barcode.rawValue;
                if (rawValue != null && rawValue.isNotEmpty) {
                  final cleanCode = rawValue.replaceAll(RegExp(r'[\s-]'), '');
                  final isDigits = RegExp(r'^[0-9]+$').hasMatch(cleanCode);
                  final isValidIsbn = isDigits && (cleanCode.length == 10 || cleanCode.length == 13);
                  
                  if (!isValidIsbn) continue;

                  if (_lastScannedCode == cleanCode) {
                    _consecutiveDetections++;
                  } else {
                    _lastScannedCode = cleanCode;
                    _consecutiveDetections = 1;
                  }

                  if (_consecutiveDetections >= 2) {
                    _consecutiveDetections = 0;
                    _lastScannedCode = null;
                    _handleBarcodeDetected(cleanCode);
                  }
                  break;
                }
              }
            },
          ),

          if (_isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  AppBar _buildTitle() {
    return AppBar(
      centerTitle: true,
      title: Text(context.l10n.scanIsbnTitle, style: context.theme.textTheme.titleLarge),
      backgroundColor: context.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          AppIcons.back,
          color: context.colorScheme.onSurface,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          icon: ValueListenableBuilder(
            valueListenable: _cameraController,
            builder: (context, state, child) {
              return Icon(
                state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                color: context.colorScheme.onSurface,
              );
            },
          ),
          onPressed: () => _cameraController.toggleTorch(),
        ),
      ],
    );
  }

  // Máscara oscura con recuadro centrado
  Widget _buildScannerOverlay(BoxConstraints constraints) {
    final scanAreaSize = constraints.maxWidth * 0.75;

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize * 0.6,
                  decoration: BoxDecoration(
                    color: context.cozy.inkColor!.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        Center(
          child: Container(
            width: scanAreaSize,
            height: scanAreaSize * 0.6,
            decoration: BoxDecoration(
              border: Border.all(
                color: context.cozy.inkColor!.withValues(alpha: 0.8),
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.l10n.scanIsbnInstruction,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Capa superpuesta durante el consumo de API
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BookLoader(),
            const SizedBox(height: 16),
            Text(
              context.l10n.scanIsbnLoading,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}