import 'package:flutter/material.dart';

class AppSettings {
  final String userId;
  final String userName;
  final String userEmail;
  final String? profileImagePath;
  final ThemeMode themeMode;
  final Locale locale;
  final bool isAlarmEnabled;
  final TimeOfDay alarmTime;
  final int yearlyGoalBooks;
  final double weeklyGoalHours;
  final bool? isPremium;
  final bool? hasSeenOnboarding;
  final bool? showExpirationBanner;
  final bool? showExpirationModal;

  const AppSettings({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.profileImagePath,
    required this.themeMode,
    required this.locale,
    required this.isAlarmEnabled,
    required this.alarmTime,
    required this.yearlyGoalBooks,
    required this.weeklyGoalHours,
    this.isPremium,
    this.hasSeenOnboarding,
    this.showExpirationBanner,
    this.showExpirationModal
  });

  /// Copia inmutable para mutaciones de estado
  AppSettings copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? profileImagePath,
    ThemeMode? themeMode,
    Locale? locale,
    bool? isAlarmEnabled,
    TimeOfDay? alarmTime,
    int? yearlyGoalBooks,
    double? weeklyGoalHours,
    bool? isPremium,
    bool? hasSeenOnboarding,
    bool? showExpirationBanner,
    bool? showExpirationModal
  }) {
    return AppSettings(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isAlarmEnabled: isAlarmEnabled ?? this.isAlarmEnabled,
      alarmTime: alarmTime ?? this.alarmTime,
      yearlyGoalBooks: yearlyGoalBooks ?? this.yearlyGoalBooks,
      weeklyGoalHours: weeklyGoalHours ?? this.weeklyGoalHours,
      isPremium: isPremium ?? this.isPremium,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      showExpirationBanner: showExpirationBanner ?? this.showExpirationBanner,
      showExpirationModal: showExpirationModal ?? this.showExpirationModal,
    );
  }
}