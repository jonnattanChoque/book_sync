// ignore_for_file: deprecated_member_use

import 'package:book_sync/core/constants/app_constants.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/export_background.dart';
import '../services/export_service.dart';
import '../widgets/export_canvas_wrapper.dart';

class ExportPreviewSheet extends ConsumerStatefulWidget {
  final Widget exportContent;
  final String shareText;
  final Map<String, bool>? cardToggles;
  final ValueChanged<Map<String, bool>>? onToggleChanged;

  const ExportPreviewSheet({
    super.key,
    required this.exportContent,
    this.shareText = '',
    this.cardToggles,
    this.onToggleChanged,
  });

  @override
  ConsumerState<ExportPreviewSheet> createState() => _ExportPreviewSheetState();
}

class _ExportPreviewSheetState extends ConsumerState<ExportPreviewSheet> {
  final GlobalKey _repaintKey = GlobalKey();
  late ExportBackground _selectedBackground;
  bool _isExporting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedBackground = ExportBackground.getPresets(context).first;
  }


  Future<void> _handleExport(bool isUserPremium) async {
    final String title = context.l10n.exportPremiumDescription(AppConstants.appName);
    if (_selectedBackground.isPremium && !isUserPremium) {
      context.push('/premium', extra: title);
      return;
    }

    setState(() => _isExporting = true);

    try {
      final imageBytes = await ExportService.captureWidget(_repaintKey);
      if (imageBytes != null && mounted) {
        await ExportService.shareImage(imageBytes, text: widget.shareText);
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgrounds = ExportBackground.getPresets(context);
    final settings = ref.watch(appSettingsProvider);
    final isPremium = settings.isPremium;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            // --- Encabezado ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.exportPreviewTitle,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Canvas con Vista Previa ---
            Center(
              child: ExportCanvasWrapper(
                boundaryKey: _repaintKey,
                backgroundDecoration: _selectedBackground.decoration,
                child: widget.exportContent,
              ),
            ),
            const SizedBox(height: 24),

            // --- Toggles de Selección de Cards (Si aplica) ---
            if (widget.cardToggles != null && widget.onToggleChanged != null) ...[
              Text(
                context.l10n.exportContentToInclude,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: widget.cardToggles!.entries.map((entry) {
                  return FilterChip(
                    label: Text(entry.key),
                    selected: entry.value,
                    onSelected: (selected) {
                      final updated = Map<String, bool>.from(widget.cardToggles!);
                      updated[entry.key] = selected;
                      widget.onToggleChanged!(updated);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // --- Selector de Fondos ---
            Text(
              context.l10n.exportBackgroundStyle,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBackgroudColors(backgrounds),
            const SizedBox(height: 24),
            _buildButton(context, isPremium ?? false),
          ],
        ),
      ),
    );
  }

  SizedBox _buildBackgroudColors(List<ExportBackground> backgrounds) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: backgrounds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final bg = backgrounds[index];
          final isSelected = bg.id == _selectedBackground.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBackground = bg;
              });
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: bg.decoration.copyWith(
                border: Border.all(
                  color: isSelected
                  ? context.theme.primaryColor
                  : Colors.transparent,
                  width: 3,
                ),
              ),
              child: bg.isPremium
    ? Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // Fondo oscuro semitransparente
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star,
              size: 12,
              color: Colors.amber,
            ),
          ),
        ),
      )
    : null,
            ),
          );
        },
      ),
    );
  }

  PrimaryOutlinedButton _buildButton(BuildContext context, bool isUserPremium ) {
    return PrimaryOutlinedButton(
      label: _isExporting ? context.l10n.exportGenerating : context.l10n.exportShareButton, 
      onPressed: () {
        if (!_isExporting) {
          _handleExport(isUserPremium);
        }
      },
      icon: _isExporting ? null : Icons.share_outlined,
      isLoading: _isExporting,
    );
  }
}