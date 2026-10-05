import 'package:flutter/material.dart';

class ExportCanvasWrapper extends StatelessWidget {
  final GlobalKey boundaryKey;
  final Widget child;
  final BoxDecoration backgroundDecoration;
  final EdgeInsetsGeometry padding;

  const ExportCanvasWrapper({
    super.key,
    required this.boundaryKey,
    required this.child,
    required this.backgroundDecoration,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: boundaryKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: padding,
        decoration: backgroundDecoration,
        child: child,
      ),
    );
  }
}