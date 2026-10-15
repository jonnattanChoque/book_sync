import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_sync/src/domain/book.dart';

final cloudRestoreCheckProvider = FutureProvider.autoDispose<bool>((ref) async {
  // 1. Obtener la instancia de Isar desde el provider
  final isar = ref.watch(isarProvider);
  
  // 2. Verificar si la app local ya tiene libros (si los tiene, no es primera instalación)
  final localBooksCount = await isar.books.count();
  if (localBooksCount > 0) return false;

  // 3. Verificar si el usuario está autenticado en Supabase
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return false;

  // 4. Consultar si existen datos remotos en la tabla de Supabase
  final response = await Supabase.instance.client
      .from('books')
      .select('id')
      .eq('user_id', userId)
      .limit(1);

  return response.isNotEmpty;
});