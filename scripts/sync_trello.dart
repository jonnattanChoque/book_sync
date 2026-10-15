import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = '9d30faeea6f70972e4ee1bb1f6975841';
const String token = 'ATTA1667cfba1d3a704532048b8ea5e3af690219a68a09106b85885c148ad05d8ae10675E432';
const String listId = '6ad04cb6b2060d592e3fa84c';
const String bugLabelId = '6ad04cb7b2060d592e3fa945';

void main() async {
  print('🔍 Buscando comentarios TODO y BUG en el código...');
  
  final dir = Directory('lib');
  final bugsAndTodos = <Map<String, dynamic>>[];

  // 1. Recorrer la carpeta lib recursivamente
  await for (var entity in dir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final lines = await entity.readAsLines();
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.contains('// BUG:') || line.contains('// TODO:')) {
          final isBug = line.contains('BUG');
          final parts = line.split(RegExp(r'(BUG|TODO):'));
          
          if (parts.length > 1) {
            final type = isBug ? '🐛 BUG' : '📌 TODO';
            final text = parts[1].trim();
            final filePath = '${entity.path}:${i + 1}';
            
            bugsAndTodos.add({
              'name': '$type: $text',
              'desc': 'Encontrado en el archivo: $filePath',
              'isBug': isBug
            });
          }
        }
      }
    }
  }

  if (bugsAndTodos.isEmpty) {
    print('No se encontraron comentarios TODO o BUG en el código.');
    return;
  }

  // 2. Obtener las tarjetas actuales que ya están en esa lista de Trello para evitar duplicados
  print('📥 Consultando tarjetas existentes en Trello...');
  final existingCardNames = await getExistingCardNamesInList(listId);

  print('Encontrados ${bugsAndTodos.length} elementos en el código. Verificando duplicados...');

  int createdCount = 0;
  int skippedCount = 0;

  // 3. Evaluar y enviar solo las que no existan
  for (var item in bugsAndTodos) {
    final cardName = item['name'] as String;

    // Si el nombre de la tarjeta ya existe en Trello, la omitimos
    if (existingCardNames.contains(cardName)) {
      print('⏩ Omitida (ya existe): $cardName');
      skippedCount++;
      continue;
    }

    final isBug = item['isBug'] as bool;
    final Map<String, String> body = {
      'key': apiKey,
      'token': token,
      'idList': listId,
      'name': cardName,
      'desc': item['desc'] as String,
    };

    if (isBug && bugLabelId.isNotEmpty) {
      body['idLabels'] = bugLabelId;
    }

    final url = Uri.parse('https://api.trello.com/1/cards');
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      print('✅ Tarjeta creada: $cardName');
      createdCount++;
    } else {
      print('❌ Error al crear tarjeta: ${response.body}');
    }
  }

  print('\n--- Resumen de Sincronización ---');
  print('✨ Tarjetas nuevas creadas: $createdCount');
  print('⏩ Tarjetas omitidas (ya existían): $skippedCount');
  print('¡Sincronización completada con éxito!');
}

// Función para obtener los nombres de todas las tarjetas activas en la lista
Future<List<String>> getExistingCardNamesInList(String targetListId) async {
  final url = Uri.parse('https://api.trello.com/1/lists/$targetListId/cards?key=$apiKey&token=$token');
  final response = await http.get(url);
  
  if (response.statusCode == 200) {
    final List<dynamic> cards = jsonDecode(response.body);
    return cards.map((card) => card['name'].toString()).toList();
  }
  
  return [];
}