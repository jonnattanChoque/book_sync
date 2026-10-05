import 'package:book_sync/core/constants/app_constants.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/export_background.dart';
import '../services/export_service.dart';
import '../widgets/export_canvas_wrapper.dart';

class ExportPreviewSheet extends ConsumerStatefulWidget {
  final Widget exportContent;
  final String shareText;
  final Map<String, bool>? cardToggles;
  final ValueChanged<Map<String, bool>>? onToggleChanged;
  final bool isUserPremium;

  const ExportPreviewSheet({
    super.key,
    required this.exportContent,
    this.shareText = '',
    this.cardToggles,
    this.onToggleChanged,
    this.isUserPremium = false,
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

  void _showPremiumPaywallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.l10n.exportPremiumTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(context.l10n.exportPremiumDescription(AppConstants.appName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.exportCancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navegar a la pantalla de Paywall / Suscripción
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(context.l10n.exportUpgradeButton),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExport() async {
    if (_selectedBackground.isPremium && !widget.isUserPremium) {
      _showPremiumPaywallDialog();
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBackgroudColors(backgrounds),
            const SizedBox(height: 24),
            _buildButton(context),
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
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
                  width: 3,
                ),
              ),
              child: bg.isPremium
              ? const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.star, size: 12, color: Colors.amber),
                  ),
                )
              : null,
            ),
          );
        },
      ),
    );
  }

  PrimaryOutlinedButton _buildButton(BuildContext context) {
    return PrimaryOutlinedButton(
      label: _isExporting ? context.l10n.exportGenerating : context.l10n.exportShareButton, 
      onPressed: () {
        if (!_isExporting) {
          _handleExport();
        }
      },
      icon: _isExporting ? null : Icons.share_outlined,
      isLoading: _isExporting,
    );
  }
}