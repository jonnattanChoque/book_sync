import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  CozyColors get cozy => Theme.of(this).extension<CozyColors>()!;
}