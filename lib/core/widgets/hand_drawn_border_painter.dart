// lib/src/core/presentation/widgets/hand_drawn_border_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

class HandDrawnBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  HandDrawnBorderPainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final random = Random(42); // Seed fija para que el borde no "baile"

    // Función para crear una línea con pequeñas desviaciones
    void drawIrregularLine(Offset start, Offset end) {
      path.moveTo(start.dx, start.dy);
      final midX = (start.dx + end.dx) / 2;
      final midY = (start.dy + end.dy) / 2;
      
      // Añadimos una desviación aleatoria en el centro de la línea
      path.quadraticBezierTo(
        midX + (random.nextDouble() * 4 - 2),
        midY + (random.nextDouble() * 4 - 2),
        end.dx,
        end.dy,
      );
    }

    // Dibujar los 4 lados
    drawIrregularLine(Offset.zero, Offset(size.width, 0));
    drawIrregularLine(Offset(size.width, 0), Offset(size.width, size.height));
    drawIrregularLine(Offset(size.width, size.height), Offset(0, size.height));
    drawIrregularLine(Offset(0, size.height), Offset.zero);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}