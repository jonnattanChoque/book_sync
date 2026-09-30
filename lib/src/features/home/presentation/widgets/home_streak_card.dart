// lib/src/features/home/presentation/widgets/streak_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_base_card.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeStreakCard extends ConsumerWidget {
  const HomeStreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(userStreakStreamProvider);

    return streakAsync.when(
      data: (userStreak) {
        final currentStreak = userStreak?.currentStreak ?? 0;
        final bestStreak = userStreak?.bestStreak ?? 0;

        return HomeBaseCard(
          onTap: () => context.push('/stats'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.streakTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.streakDaysCount(currentStreak),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.cozy.inkColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.bestStreakLabel(bestStreak),
                style: TextStyle(
                  fontSize: 13,
                  color: context.cozy.inkColor?.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const HomeBaseCard(
        child: SizedBox(
          height: 60,
          child: Center(child: BookLoader()),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}