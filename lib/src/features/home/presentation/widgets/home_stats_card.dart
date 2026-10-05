// lib/src/features/home/presentation/widgets/stats_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatsCard extends ConsumerWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeBaseCard(
      onTap: () => context.push('/stats'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.statsTitle(DateTime.now().year.toString()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.cozy.bookmarkColor!.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: context.cozy.bookmarkColor,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.statsDescription,
            style: TextStyle(
              fontSize: 14,
              color: context.cozy.inkColor?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}