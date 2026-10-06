import 'package:book_sync/core/services/preferences_service.dart';
import 'package:book_sync/core/utils/user_helper.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:book_sync/src/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;
  final Isar _isar;
  final PreferencesService _preferencesService;

  SupabaseAuthRepository(
    this._client, this._isar,
    this._preferencesService
  ) {
    // Escuchamos los cambios del Stream dentro del repositorio
    _client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if ((event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) && session != null) {
        await syncSupabaseUserToIsar(_isar, session.user);
      }
    });
  }

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: '111556282144-qrvk0vnorofr2ccf1r8rmqmfpim4glua.apps.googleusercontent.com',
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('No se encontró el ID Token de Google.');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        await _preferencesService.setGuestMode(false);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithApple() async {
  try {
    // 1. Solicitar credenciales nativas de Apple
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('No se obtuvo el identityToken de Apple.');
    }

    // 2. Iniciar sesión nativamente en Supabase
    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      accessToken: credential.authorizationCode,
    );

    // 3. Sincronizar datos de usuario
    if (response.user != null) {
      final session = _client.auth.currentSession;
      if (session != null) {
        await syncSupabaseUserToIsar(_isar, session.user);
      }
      await _preferencesService.setGuestMode(false);
    }
  } catch (e) {
    rethrow;
  }
}

  @override
  Future<void> signInAnonymously() async {
    await _client.auth.signInAnonymously();
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

class IsarRepository {
}