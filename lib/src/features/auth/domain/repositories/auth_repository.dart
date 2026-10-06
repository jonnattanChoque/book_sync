import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<AuthState> get authStateChanges;
  
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signInAnonymously();
  Future<void> signOut();
}