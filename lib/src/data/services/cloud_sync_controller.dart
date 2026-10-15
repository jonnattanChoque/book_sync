import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/data/services/cloud_sync_service.dart';

final autoSyncProvider = Provider.autoDispose((ref) {
  return AutoSyncController(ref);
});

class AutoSyncController {
  final Ref _ref;
  bool _isSyncing = false;

  AutoSyncController(this._ref);

  /// Ejecuta una sincronización en segundo plano sin interrumpir la experiencia del usuario
  Future<void> triggerSilentSync() async {
    final settings = _ref.read(appSettingsProvider);
    final isPremium = settings.isPremium ?? false;

    // Si no es premium o ya hay una sincronización en curso, omitimos
    if (!isPremium || _isSyncing) return;

    _isSyncing = true;
    try {
      final isar = _ref.read(isarProvider);
      final syncService = CloudSyncService(isar);
      await syncService.exportAllDataToCloud();
    } catch (e) {
      print('Auto-sync silencioso omitido/fallido: $e');
    } finally {
      _isSyncing = false;
    }
  }
}