// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Good afternoon,';

  @override
  String get welcomeMessage => 'Stories reader';

  @override
  String get userName => 'Story Reader';

  @override
  String get dailyQuotePlaceholder =>
      '\"Reading is a dream that you hold in your hands.\"';

  @override
  String get addBook => 'Add book';
}
