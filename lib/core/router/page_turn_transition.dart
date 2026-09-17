import 'package:flutter/material.dart';
import 'package:paperfold/paperfold.dart';

Widget buildPageTurnTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, childWidget) {
      // animation.value va de 0.0 (totalmente doblado) a 1.0 (completamente abierto)
      final double progress = animation.value;
      
      // Obtenemos el ratio de píxeles del dispositivo actual para evitar valores nulos
      final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

      return PaperFold(
        foldValue: progress, // Valor del despliegue (0.0 a 1.0)
        strips: 3, // Número de pliegues verticales
        pixelRatio: devicePixelRatio, // Valor de densidad de pantalla\
        child: childWidget!,
      );
    },
    child: child,
  );
}