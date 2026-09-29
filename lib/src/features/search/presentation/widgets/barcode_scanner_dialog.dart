import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:book_sync/core/theme/app_colors.dart';

class BarcodeScannerDialog extends StatefulWidget {
  const BarcodeScannerDialog({super.key});

  static Future<String?> scanBarcode(BuildContext context) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      if (!context.mounted) return null;
      return await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => const BarcodeScannerDialog(),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return null;
  }

  @override
  State<BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<BarcodeScannerDialog> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isScanned = false;
  String? _lastScannedCode;
  int _consecutiveDetections = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _controller.stop();
        break;
      case AppLifecycleState.resumed:
        _controller.start();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(String rawValue) {
    if (_isScanned) return;

    // 1. Limpia espacios o guiones
    final cleanCode = rawValue.replaceAll(RegExp(r'[\s-]'), '');

    // 2. Filtro estricto: Debe ser estrictamente un ISBN numérico de 10 o 13 dígitos
    final isDigits = RegExp(r'^[0-9]+$').hasMatch(cleanCode);
    final isValidIsbnLength = isDigits && (cleanCode.length == 10 || cleanCode.length == 13);

    if (!isValidIsbnLength) return;

    // 3. Confirmación de enfoque: Requiere 2 lecturas consecutivas idénticas
    if (_lastScannedCode == cleanCode) {
      _consecutiveDetections++;
    } else {
      _lastScannedCode = cleanCode;
      _consecutiveDetections = 1;
    }

    if (_consecutiveDetections >= 2) {
      _isScanned = true;
      Navigator.of(context).pop(cleanCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.beigePaper),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Escanear ISBN',
          style: TextStyle(color: AppColors.beigePaper),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: AppColors.beigePaper,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam_off, color: Colors.white, size: 48),
                    const SizedBox(height: 12),
                    const Text('Error al acceder a la cámara', style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _controller.start(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            },
            onDetect: (capture) {
              if (_isScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null && rawValue.isNotEmpty) {
                  _onBarcodeDetected(rawValue);
                  break;
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 260,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.beigePaper.withValues(alpha: 0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}