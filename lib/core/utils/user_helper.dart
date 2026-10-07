import 'package:book_sync/src/domain/app_config.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> syncSupabaseUserToIsar(Isar isar, User user) async {
  // 1. Obtener el registro de AppConfig (o crear uno si no existe)
  final appConfig = await isar.appConfigs
      .filter()
      .userIdEqualTo(user.id)
      .findFirst() ?? 
  AppConfig()..userId = user.id;

  // 2. Si es usuario anónimo (Invitado), asignamos los datos por defecto
  if (user.isAnonymous) {
    appConfig.userName = 'Lector de Historias';
    appConfig.userEmail = 'invitado@example.com';
    appConfig.profileImagePath = '';
  } else {
    // 3. Extraer metadatos de Supabase
    final metadata = user.userMetadata;

    // Email
    if (user.email != null && user.email!.isNotEmpty) {
      appConfig.userEmail = user.email!;
    }

    // Nombre (Google o Apple)
    String? name;
    if (metadata != null) {
      if (metadata['full_name'] != null && metadata['full_name'].toString().trim().isNotEmpty) {
        name = metadata['full_name'].toString().trim();
      } else if (metadata['name'] != null) {
        final nameData = metadata['name'];
        if (nameData is String && nameData.trim().isNotEmpty) {
          name = nameData.trim();
        } else if (nameData is Map) {
          final firstName = nameData['firstName'] ?? '';
          final lastName = nameData['lastName'] ?? '';
          name = '$firstName $lastName'.trim();
        }
      }
    }

    // Si encontramos nombre lo guardamos, de lo contrario usamos el correo o el valor por defecto
    if (name != null && name.isNotEmpty) {
      appConfig.userName = name;
    } else if (user.email != null) {
      appConfig.userName = user.email!.split('@').first;
    }

    // Foto de perfil / Avatar (si Google la provee)
    if (metadata != null && metadata['avatar_url'] != null) {
      appConfig.profileImagePath = metadata['avatar_url'].toString();
    }
  }

  // 4. Guardar los cambios actualizados en Isar
  await isar.writeTxn(() async {
    await isar.appConfigs.put(appConfig);
  });
}