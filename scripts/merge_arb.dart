import 'dart:convert';
import 'dart:io';

void main() async {
  final l10nDir = Directory('lib/l10n/src');
  if (!await l10nDir.exists()) {
    print('Error: El directorio lib/l10n/src no existe.');
    exit(1);
  }

  await mergeLocales('es', l10nDir);
  await mergeLocales('en', l10nDir);
}

Future<void> mergeLocales(String locale, Directory srcDir) async {
  final Map<String, dynamic> mergedMap = {
    '@@locale': locale,
  };

  final List<FileSystemEntity> files = await srcDir.list(recursive: true).toList();

  for (final file in files) {
    if (file is File && file.path.endsWith('_${locale}.arb')) {
      try {
        final content = await file.readAsString();
        if (content.trim().isEmpty) continue;

        final Map<String, dynamic> jsonMap = json.decode(content);

        jsonMap.forEach((key, value) {
          if (key != '@@locale') {
            mergedMap[key] = value;
          }
        });
      } catch (e) {
        print('Error al procesar el archivo ${file.path}: $e');
      }
    }
  }

  final outputFile = File('lib/l10n/app_$locale.arb');
  const encoder = JsonEncoder.withIndent('  ');
  await outputFile.writeAsString(encoder.convert(mergedMap));
  print('Generado exitosamente: ${outputFile.path}');
}