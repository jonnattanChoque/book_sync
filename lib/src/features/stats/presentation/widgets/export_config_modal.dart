import 'package:book_sync/core/domain/entities/export_item_type.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';

class ExportConfigModal extends StatefulWidget {
  final List<ExportItemConfig> initialItems;

  const ExportConfigModal({
    super.key,
    required this.initialItems,
  });

  static Future<List<ExportItemConfig>?> show(
    BuildContext context, {
    required List<ExportItemConfig> initialItems,
  }) {
    return showModalBottomSheet<List<ExportItemConfig>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ExportConfigModal(initialItems: initialItems),
    );
  }

  @override
  State<ExportConfigModal> createState() => _ExportConfigModalState();
}

class _ExportConfigModalState extends State<ExportConfigModal> {
  late List<ExportItemConfig> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.initialItems
    .map((e) => ExportItemConfig(
      type: e.type,
      title: e.title,
      isVisible: e.isVisible,
    ))
    .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.exportCustomizeTitle,
                style: context.theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.exportCustomizeSubtitle,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final item = _items[index];
                return CheckboxListTile(
                  key: ValueKey(item.type),
                  title: Text(
                    item.title,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: item.isVisible,
                  secondary: const Icon(Icons.drag_handle_rounded),
                  onChanged: (val) {
                    setState(() {
                      item.isVisible = val ?? true;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: PrimaryOutlinedButton(
              icon: Icons.preview_rounded,
              label: context.l10n.exportGeneratePreview,
              onPressed: () {
                Navigator.of(context).pop(_items);
              },
            ),
          ),
        ],
      ),
    );
  }
}