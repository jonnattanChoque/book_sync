import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';

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
    final cozy = Theme.of(context).extension<CozyColors>()!;
    

    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.5)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Expanded(
                child: Container(
                  color: cozy.inkColor!.withValues(alpha: 0.05),
                  child: Center(
                    child: Icon(Icons.add, color: cozy.inkColor!.withValues(alpha: 0.8), size: 70),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(AppLocalizations.of(context)!.noBooksSubtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              
            ],
          ),
        ),
      ),
    );
  }
}