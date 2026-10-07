import 'package:book_sync/core/data/datasources/app_config_datasource.dart';
import 'package:book_sync/core/domain/entities/app_settings_stat.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/services/notification_service.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para acceder al Datasource de AppConfig
final appConfigDatasourceProvider = Provider<AppConfigDatasource>((ref) {
  final isar = ref.watch(isarProvider);
  return AppConfigDatasource(isar);
});

/// Provider global de configuraciones consumible en toda la app
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  throw UnimplementedError(
    'appSettingsProvider debe ser sobreescrito en main.dart mediante overrideWith',
  );
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final AppConfigDatasource _datasource;

  AppSettingsNotifier(super.initialState, this._datasource);

  /// Actualiza los datos del perfil
  Future<void> updateUserData({
    required String name,
    String? profileImagePath,
  }) async {
    state = state.copyWith(
      userName: name,
      profileImagePath: profileImagePath ?? state.profileImagePath,
    );
    await _datasource.saveSettings(state);
  }

  Future<void> loadUserFromSupabase(AppConfig appConfig) async {
    await _datasource.udpateLoginInfo(appConfig);
    final updatedSettings = await _datasource.getOrInitSettings(appConfig.userId);
    state = updatedSettings;
  }

  /// Cambia el modo de tema en caliente (3.4.2)
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _datasource.saveSettings(state);
  }

  Future<void> updatePremium(bool isPremium) async {
    state = state.copyWith(isPremium: isPremium);
    await _datasource.saveSettings(state);
  }

  /// Cambia el idioma dinámicamente (3.4.3)
  Future<void> updateLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _datasource.saveSettings(state);
  }

  /// Configura el recordatorio/alarma de lectura (3.4.4)
  Future<void> updateReadingAlarm({
    required bool isEnabled,
    TimeOfDay? alarmTime,
  }) async {
    state = state.copyWith(
      isAlarmEnabled: isEnabled,
      alarmTime: alarmTime ?? state.alarmTime,
    );
    await _datasource.saveSettings(state);
  }

  /// Actualiza los objetivos cuantitativos de lectura (3.4.5)
  Future<void> updateReadingGoals({
    int? yearlyGoalBooks,
    double? weeklyGoalHours,
  }) async {
    state = state.copyWith(
      yearlyGoalBooks: yearlyGoalBooks ?? state.yearlyGoalBooks,
      weeklyGoalHours: weeklyGoalHours ?? state.weeklyGoalHours,
    );
    await _datasource.saveSettings(state);
  }

  Future<void> updateReadingReminder({
    required bool isEnabled,
    required TimeOfDay? time,
    required BuildContext context,
  }) async {
    if (isEnabled && time != null) {
      await NotificationService.scheduleDailyReadingReminder( 
        hour: time.hour,
        minute: time.minute,
        title: context.l10n.notificationTitle,
        body: context.l10n.notificationBody,
        channelName: context.l10n.notificationChannelName,
        channelDescription: context.l10n.notificationChannelDescription,
      );
    } else {
      await NotificationService.cancelReadingReminder();
    }
  }

  Future<void> logout() async {
    //await _datasource.clearAppConfig();
  }
}