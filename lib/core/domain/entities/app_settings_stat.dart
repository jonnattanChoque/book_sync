import 'package:flutter/material.dart';

class AppSettings {
  final String userName;
  final String userEmail;
  final String? profileImagePath;
  final ThemeMode themeMode;
  final Locale locale;
  final bool isAlarmEnabled;
  final TimeOfDay alarmTime;
  final int yearlyGoalBooks;
  final double weeklyGoalHours;

  const AppSettings({
    required this.userName,
    required this.userEmail,
    this.profileImagePath,
    required this.themeMode,
    required this.locale,
    required this.isAlarmEnabled,
    required this.alarmTime,
    required this.yearlyGoalBooks,
    required this.weeklyGoalHours,
  });

  /// Copia inmutable para mutaciones de estado
  AppSettings copyWith({
    String? userName,
    String? userEmail,
    String? profileImagePath,
    ThemeMode? themeMode,
    Locale? locale,
    bool? isAlarmEnabled,
    TimeOfDay? alarmTime,
    int? yearlyGoalBooks,
    double? weeklyGoalHours,
  }) {
    return AppSettings(
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isAlarmEnabled: isAlarmEnabled ?? this.isAlarmEnabled,
      alarmTime: alarmTime ?? this.alarmTime,
      yearlyGoalBooks: yearlyGoalBooks ?? this.yearlyGoalBooks,
      weeklyGoalHours: weeklyGoalHours ?? this.weeklyGoalHours,
    );
  }
}