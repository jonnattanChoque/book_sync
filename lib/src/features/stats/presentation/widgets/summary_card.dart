import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final Widget? content;

  const SummaryCard({super.key, required this.title, this.value, this.icon, this.content});

  @override
  Widget build(BuildContext context) {
    return CustomInfoCardContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: context.cozy.bookmarkColor?.withValues(alpha: 0.6),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (content != null)
            content!
          else if (value != null)
            Text(
              value!,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
        ],
      ) 
    );
  }
}