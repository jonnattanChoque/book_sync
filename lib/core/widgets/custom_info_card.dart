import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class CustomInfoCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CustomInfoCardContainer({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cozy = context.cozy;

    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: cozy.inkColor?.withValues(alpha: 0.2) ?? Colors.grey.shade300,
        ),
      ),
      child: child,
    );
  }
}