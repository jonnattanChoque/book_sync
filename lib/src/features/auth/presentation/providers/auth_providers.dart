import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/providers/preferences_provider.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_sync/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:book_sync/src/features/auth/data/repositories/supabase_auth_repository.dart';

// 1. Provider del cliente de Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// 2. Provider del Repositorio
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final isar = ref.watch(isarProvider);
  final preferencesService = ref.watch(preferencesServiceProvider);
  
  return SupabaseAuthRepository(
    client, 
    isar, 
    preferencesService,
    onUserAuthenticated: (user) async {
      final appConfig = await isar.appConfigs
          .filter()
          .userIdEqualTo(user.id)
          .findFirst();

      if (appConfig != null) {
        await ref.read(appSettingsProvider.notifier).loadUserFromSupabase(appConfig);
      }
    },
  );
});

// 3. StreamProvider para escuchar cambios de sesión en tiempo real
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// 4. Controller para manejar estados de carga y errores durante el login
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.signInWithGoogle());
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signInWithApple();
      await _ref.read(preferencesServiceProvider).setGuestMode(false);
    });
  }

  Future<void> continueAsGuest() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signInAnonymously();
      await _ref.read(preferencesServiceProvider).setGuestMode(true);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // 1. Limpiar sesión de Supabase
      await _repository.signOut();
      
      // 2. Opcional: Limpiar o resetear estado local en Isar/Preferences si aplica
      await _ref.read(preferencesServiceProvider).setGuestMode(true);
    });
  }
}