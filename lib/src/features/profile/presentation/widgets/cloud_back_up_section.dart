import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/src/data/services/cloud_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CloudBackupTile extends ConsumerStatefulWidget {
  const CloudBackupTile({super.key});

  @override
  ConsumerState<CloudBackupTile> createState() => _CloudBackupTileState();
}

class _CloudBackupTileState extends ConsumerState<CloudBackupTile> {
  bool _isSyncing = false;

  Future<void> _handleCloudExport(bool isPremium) async {
    final l10n = context.l10n;

    if (!isPremium) {
      final String title = context.l10n.exportToCloudSubtitle;
      context.push('/premium', extra: {'title': title});
      return;
    }

    setState(() => _isSyncing = true);

    try {
      // Asumiendo que 'isar' está disponible a través de Riverpod o tu contenedor
      final syncService = CloudSyncService(ref.read(isarProvider));
      await syncService.exportAllDataToCloud();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.backupSuccessMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.backupErrorMessage(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
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
        Icons.cloud_upload_outlined,
        color: isPremium ? context.theme.colorScheme.primary : Colors.grey,
      ),
      title: Row(
        children: [
          Text(l10n.exportToCloudTitle),
          if (!isPremium) ...[
            const SizedBox(width: 8),
            const Icon(Icons.star, size: 16, color: Colors.amber),
          ],
        ],
      ),
      subtitle: Text(l10n.exportToCloudSubtitle),
      trailing: _isSyncing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: () => _handleCloudExport(isPremium),
    );
  }
}