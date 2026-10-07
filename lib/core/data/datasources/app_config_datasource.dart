import 'package:book_sync/core/domain/entities/app_settings_stat.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class AppConfigDatasource {
  final Isar isar;

  AppConfigDatasource(this.isar);

  /// Obtiene o inicializa la configuración única en Isar DB
  Future<AppSettings> getOrInitSettings(String? userId) async {
    final configCollection = isar.collection<AppConfig>();
    
    // Buscamos el AppConfig que corresponda exactamente al userId actual
    AppConfig? config = await configCollection
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    // Si no existe una configuración para este usuario, creamos una nueva asociada a él
    if (config == null) {
      config = AppConfig()..userId = userId;
      await isar.writeTxn(() async {
        await configCollection.put(config!);
      });
    }

    return _mapToEntity(config);
  }
  
  Future<void> udpateLoginInfo(AppConfig appConfig) async {
    await isar.writeTxn(() async {
      await isar.appConfigs.put(appConfig);
    });
  }
  
  /// Guarda los cambios actualizando el único registro de AppConfig
  Future<void> saveSettings(AppSettings settings) async {
    final configCollection = isar.collection<AppConfig>();

    await isar.writeTxn(() async {
      AppConfig config = await configCollection.where().findFirst() ?? AppConfig();

      config.userId = settings.userId;
      config.userName = settings.userName;
      config.userEmail = settings.userEmail;
      config.profileImagePath = settings.profileImagePath ?? '';
      config.themeMode = settings.themeMode.name;
      config.languageCode = settings.locale.languageCode;
      config.isAlarmEnabled = settings.isAlarmEnabled;
      config.alarmHour = settings.alarmTime.hour;
      config.alarmMinute = settings.alarmTime.minute;
      config.yearlyGoalBooks = settings.yearlyGoalBooks;
      config.weeklyGoalHours = settings.weeklyGoalHours;
      config.isPremium = settings.isPremium ?? false;

      await configCollection.put(config);
    });
  }

  Future<void> clearAppConfig() async {
    await isar.writeTxn(() async {
      await isar.appConfigs.clear(); 
    });
  }
  
  /// Mapeador privado de AppConfig (Isar) -> AppSettings (Domain)
  AppSettings _mapToEntity(AppConfig config) {
    ThemeMode mode;
    switch (config.themeMode) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
    }

    final validYearlyBooks = (config.yearlyGoalBooks > 0 && 
          config.yearlyGoalBooks < 1000)
      ? config.yearlyGoalBooks
      : 12; // Valor por defecto razonable

    // Previene NaN, Infinity o valores negativos/desorbitados en dobles
    final validWeeklyHours = (config.weeklyGoalHours.isNaN || 
          config.weeklyGoalHours.isInfinite || 
          config.weeklyGoalHours <= 0)
      ? 5.0 // Valor por defecto razonable
      : config.weeklyGoalHours;

    final validHour = (config.alarmHour >= 0 && config.alarmHour < 24)
      ? config.alarmHour
      : 20; // Valor por defecto: 8 PM
      
    final validMinute = (config.alarmMinute >= 0 && config.alarmMinute < 60)
      ? config.alarmMinute
      : 0;

    // Validación de seguridad para evitar cadenas vacías o nulas que rompan Locale
    final lang = (config.languageCode.isNotEmpty) 
        ? config.languageCode 
        : 'es';

    return AppSettings(
      userId: config.userId ?? '01',
      userName: config.userName,
      userEmail: config.userEmail,
      profileImagePath: config.profileImagePath.isNotEmpty ? config.profileImagePath : null,
      themeMode: mode,
      locale: Locale(lang),
      isAlarmEnabled: config.isAlarmEnabled,
      alarmTime: TimeOfDay(
        hour: validHour,
        minute: validMinute,
      ),
      yearlyGoalBooks: validYearlyBooks,
      weeklyGoalHours: validWeeklyHours,
      isPremium: config.isPremium
    );
  }
}