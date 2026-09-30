// lib/src/features/home/presentation/widgets/home_base_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class HomeBaseCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HomeBaseCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.theme.cardColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.cozy.bookmarkColor!.withValues(alpha: 0.2),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}