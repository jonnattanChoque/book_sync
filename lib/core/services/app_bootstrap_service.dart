import 'package:book_sync/core/data/datasources/app_config_datasource.dart';
import 'package:book_sync/core/domain/entities/app_settings_stat.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/providers/preferences_provider.dart';
import 'package:book_sync/core/services/notification_service.dart';
import 'package:book_sync/core/services/preferences_service.dart';
import 'package:book_sync/core/services/subscription_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';

class BootstrapResult {
  final List<Override> overrides;
  BootstrapResult(this.overrides);
}

class AppBootstrapService {
  final ProviderContainer _container;
  final Session? currentSession;
  final String? activeUserId;
  final Isar isar;
  final AppSettings userSettings;
  final AppConfigDatasource datasource;

  AppBootstrapService(this._container, {required this.currentSession, required this.activeUserId, required this.userSettings, required this.isar, required this.datasource});

  Future<BootstrapResult> init() async {
    if (currentSession != null) {
      await SubscriptionService.logIn(activeUserId!);
    } else {
      await SubscriptionService.logOut();
    }

    
    final isPremiumUser = await SubscriptionService.isPremium();
    await _container.read(appSettingsProvider.notifier).updatePremium(isPremiumUser);

    // 2. EL LISTENER DE SUPABASE PARA FUTUROS LOGINS/LOGOUTS
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final newUserId = session?.user.id;

      if (session != null) {
        await SubscriptionService.logIn(newUserId!);
      } else {
        await SubscriptionService.logOut();
      }

      final isPremium = await SubscriptionService.isPremium();
       await _container.read(appSettingsProvider.notifier).updatePremium(isPremium);
    });

    final sharedPreferences = await SharedPreferences.getInstance();
    await NotificationService.init();

    return BootstrapResult([
      isarProvider.overrideWithValue(isar),
      appSettingsProvider.overrideWith(
        (ref) => AppSettingsNotifier(userSettings, datasource),
      ),
      preferencesServiceProvider.overrideWithValue(
        PreferencesService(sharedPreferences),
      ),
    ]);
  }
}