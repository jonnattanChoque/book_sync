import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';

class CozyToast {
  static void showSuccess(
    BuildContext context, {
    required String title,
    String? description,
    IconData icon = Icons.bookmark_added_rounded,
  }) {
    final cozy = context.theme.extension<CozyColors>();

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: cozy?.textColor ?? context.theme.colorScheme.onSurface,
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: TextStyle(
                color: cozy?.inkColor?.withValues(alpha: 0.7) ??
                  context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            )
          : null,
      icon: Icon(
        icon,
        color: cozy?.bookmarkColor ?? context.theme.colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      borderSide: BorderSide(
        color: cozy?.inkColor?.withValues(alpha: 0.3) ??
            context.theme.colorScheme.outline.withValues(alpha: 0.3),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: (cozy?.inkColor ?? Colors.black).withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      showProgressBar: false,
      // ignore: deprecated_member_use
      closeButtonShowType: CloseButtonShowType.none,
    );
  }
}