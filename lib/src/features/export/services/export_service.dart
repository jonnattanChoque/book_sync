import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ExportService {
  /// Captura un widget envuelto en un RepaintBoundary y lo devuelve como Uint8List (PNG)
  static Future<Uint8List?> captureWidget(GlobalKey key, {double pixelRatio = 3.0}) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Generar imagen con alta resolución (pixelRatio 3.0 para nitidez en redes)
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error al capturar la imagen: $e');
      return null;
    }
  }

  /// Guarda temporalmente la imagen y abre el menú nativo de compartir
  static Future<void> shareImage(Uint8List imageBytes, {String text = ''}) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/shared_reading_export_${DateTime.now().millisecondsSinceEpoch}.png').create();
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: text,
    );
  }
}