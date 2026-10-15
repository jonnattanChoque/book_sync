import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/src/data/services/cloud_restore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloudImportTile extends ConsumerStatefulWidget {
  const CloudImportTile({super.key});

  @override
  ConsumerState<CloudImportTile> createState() => _CloudImportTileState();
}

class _CloudImportTileState extends ConsumerState<CloudImportTile> {
  bool _isRestoring = false;

  Future<void> _handleCloudImport(bool isPremium) async {
    final l10n = context.l10n;

    if (!isPremium) {
      // Si no es premium, abrimos el Paywall
      return;
    }

    setState(() => _isRestoring = true);

    try {
      final restoreService = CloudRestoreService(ref.read(isarProvider));
      await restoreService.restoreAllDataFromCloud();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importSuccessMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.importErrorMessage(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(appSettingsProvider);
    final isPremium = settings.isPremium ?? false;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.cloud_download_outlined,
        color: isPremium ? context.theme.colorScheme.primary : Colors.grey,
      ),
      title: Row(
        children: [
          Text(l10n.importFromCloudTitle),
          if (!isPremium) ...[
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 16, color: Colors.amber),
          ],
        ],
      ),
      subtitle: Text(l10n.importFromCloudSubtitle),
      trailing: _isRestoring
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: () => _handleCloudImport(isPremium),
    );
  }
}