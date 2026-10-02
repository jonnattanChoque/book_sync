// lib/src/features/home/presentation/widgets/profile_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeProfileCard extends ConsumerWidget {
  const HomeProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cuando se implemente la feature de Perfil, aquí se consumirá su Provider.
    final userName = "";//context.l10n.defaultUserName;
    final readerLevel = "";//context.l10n.readerLevelDefault;

    return HomeBaseCard(
      onTap: () => context.push('/profile'),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.cozy.bookmarkColor!.withValues(alpha: 0.2),
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.cozy.inkColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  readerLevel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.cozy.bookmarkColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.cozy.inkColor?.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}