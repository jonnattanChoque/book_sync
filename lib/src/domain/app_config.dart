import 'package:isar/isar.dart';

part 'app_config.g.dart'; 

@collection
class AppConfig {
  Id id = Isar.autoIncrement;

  @Index()
  String? userId;

  // Campos existentes de citas y frases
  String? lastBookmarkAnimDate;
  String? dailyQuoteText;
  String? dailyQuoteAuthor;

  // 3.4.1 Datos de usuario
  String userName = 'Lector de Historias';
  String userEmail = 'lector@example.com';
  String profileImagePath = ''; // Nueva propiedad para la ruta de la imagen de perfil

  String themeMode = 'system'; // 'system', 'light', 'dark'
  String languageCode = 'es'; // 'es', 'en'
  bool? isPremium;

  // 3.4.4 Alarma de lectura
  bool isAlarmEnabled = false;
  int alarmHour = 20;
  int alarmMinute = 0;

  // 3.4.5 Objetivos de lectura
  int yearlyGoalBooks = 12;
  double weeklyGoalHours = 5.0;
}