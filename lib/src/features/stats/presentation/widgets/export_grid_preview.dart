import 'package:book_sync/core/domain/entities/export_item_type.dart';
import 'package:flutter/material.dart';

class ExportGridPreview extends StatelessWidget {
  final List<ExportItemConfig> items;

  const ExportGridPreview({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // 1. Filtrar solo los elementos visibles
    final visibleItems = items.where((e) => e.isVisible).toList();
    final isOdd = visibleItems.length.isOdd;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final halfWidth = (totalWidth - 12) / 2; // 12px de espaciado intermedio

        List<Widget> rows = [];
        int i = 0;

        while (i < visibleItems.length) {
          // Si es el último elemento Y la lista visible es impar
          if (i == visibleItems.length - 1 && isOdd) {
            rows.add(
              SizedBox(
                width: totalWidth, // Toma todo el ancho
                child: _buildExportCard(visibleItems[i]),
              ),
            );
            i++;
          } else {
            // Emparejar de 2 en 2
            final firstItem = visibleItems[i];
            final secondItem = visibleItems[i + 1];

            rows.add(
              Row(
                children: [
                  SizedBox(
                    width: halfWidth,
                    child: _buildExportCard(firstItem),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: halfWidth,
                    child: _buildExportCard(secondItem),
                  ),
                ],
              ),
            );
            i += 2;
          }
        }

        return Column(
          children: rows
              .map((row) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: row,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildExportCard(ExportItemConfig item) {
    // Aquí renderizas cada tarjeta real según su tipo
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}