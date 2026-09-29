import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:flutter/material.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryOutlinedButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: BookLoader(),
              )
            : Icon(
                icon,
                color: context.theme.colorScheme.onSurface,
              ),
          label: Text(
            label,
            style: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          onPressed: isLoading ? null : onPressed,
        ),
      ),
    );
  }
}