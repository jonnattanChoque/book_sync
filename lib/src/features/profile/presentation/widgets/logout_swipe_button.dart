import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

class LogoutSwipeButton extends ConsumerWidget {
  const LogoutSwipeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SwipeButton.expand(
        thumb: const Icon(
          Icons.power_settings_new_rounded,
          color: Colors.white,
        ),
        activeThumbColor: Colors.redAccent,
        activeTrackColor: isDark 
        ? Colors.redAccent.withValues(alpha: 0.2) 
        : Colors.red.shade50,
        borderRadius: BorderRadius.circular(30),
        height: 56,
        child: Text(
          context.l10n.authSlideToSignOut,
          style: TextStyle(
            color: isDark ? Colors.red.shade200 : Colors.red.shade800,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        onSwipe: () async {
          final authNotifier = ref.read(authControllerProvider.notifier);
          final settingsNotifier = ref.read(appSettingsProvider.notifier);
          
          await authNotifier.signOut();
          await settingsNotifier.logout();
          
          if (!context.mounted) return;
          CozyToast.showSuccess(context, title: context.l10n.authSignOutSuccess);
        },
      ),
    );
  }
}