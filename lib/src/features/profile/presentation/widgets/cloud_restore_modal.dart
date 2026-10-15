import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/src/data/services/cloud_restore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloudRestoreModal extends ConsumerStatefulWidget {
  const CloudRestoreModal({super.key});

  @override
  ConsumerState<CloudRestoreModal> createState() => _CloudRestoreModalState();
}

class _CloudRestoreModalState extends ConsumerState<CloudRestoreModal> {
  bool _isLoading = false;

  Future<void> _handleRestore() async {
    setState(() => _isLoading = true);
    try {
      final isar = ref.read(isarProvider);
      final restoreService = CloudRestoreService(isar);
      await restoreService.restoreAllDataFromCloud();

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importErrorMessage(e.toString()))),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.cloudBackupFoundTitle),
      content: Text(
        l10n.cloudBackupFoundMessage, style: context.theme.textTheme.bodyMedium?.copyWith(
          color: context.cozy.textColor?.withValues(alpha: 0.7),
        )
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.startFromScratchButton),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleRestore,
          child: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(l10n.restoreDataButton),
        ),
      ],
    );
  }
}