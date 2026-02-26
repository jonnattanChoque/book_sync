// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => 'Buenas tardes,';

  @override
  String get welcomeMessage => 'Lector de historias';

  @override
  String get userName => 'Lector de Historias';

  @override
  String get dailyQuotePlaceholder =>
      '\"La lectura es un sueño que tienes en tus manos.\"';

  @override
  String get addBook => 'Agregar libro';
}
