// lib/core/services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyIsGuest = 'is_guest_mode';
  static const String _keyHasSeenAuth = 'has_seen_auth';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // Guardar flag cuando presiona "Explorar como invitado"
  Future<void> setGuestMode(bool value) async {
    await _prefs.setBool(_keyIsGuest, value);
    await _prefs.setBool(_keyHasSeenAuth, true);
  }

  bool get isGuest => _prefs.getBool(_keyIsGuest) ?? false;
  bool get hasSeenAuth => _prefs.getBool(_keyHasSeenAuth) ?? false;

  // Limpiar para cuando cierre sesión o quiera vincular cuenta
  Future<void> clearAuthPreferences() async {
    await _prefs.remove(_keyIsGuest);
    await _prefs.remove(_keyHasSeenAuth);
  }
}