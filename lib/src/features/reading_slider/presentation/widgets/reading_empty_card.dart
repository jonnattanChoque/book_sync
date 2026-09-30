import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:flutter/material.dart';

class ReadingEmptyCard extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const ReadingEmptyCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(color: context.cozy.inkColor!.withValues(alpha: 0.5)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.theme.textTheme.titleLarge),
              Expanded(
                child: Container(
                  color: context.cozy.inkColor!.withValues(alpha: 0.05),
                  child: Center(
                    child: Icon(Icons.add, color: context.cozy.inkColor!.withValues(alpha: 0.8), size: 70),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(context.l10n.noBooksSubtitle, style: context.theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              
            ],
          ),
        ),
      ),
    );
  }
}