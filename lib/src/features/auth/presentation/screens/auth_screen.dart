// lib/src/features/auth/presentation/screens/auth_screen.dart

import 'dart:io';
import 'package:book_sync/core/providers/preferences_provider.dart';
import 'package:book_sync/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),
              
              // 1. Branding / Logo & Mensaje de Bienvenida
              _buildHeader(context),

              const Spacer(),

              // 2. Beneficios de Iniciar Sesión (Card explicativa)
              _buildBenefitsCard(context),

              const SizedBox(height: 32),

              // 3. Botones de Acción Social & Invitado
              _buildAuthButtons(context, ref),

              const SizedBox(height: 16),

              // 4. Disclaimer de Modo Invitado
              Text(
                context.l10n.authGuestDisclaimer,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: context.cozy.bookmarkColor?.withValues(alpha: 0.15) ?? context.theme.primaryColor.withValues(alpha: 0.15),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/app_logo.png',
              width: 48,
              height: 48,
              errorBuilder: (_, _, _) => Icon(
                Icons.auto_stories_rounded,
                size: 40,
                color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.authWelcomeTitle,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.authWelcomeSubtitle,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cozy.inkColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.authLoginBenefitsTitle,
            style: context.theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildBenefitRow(context, Icons.cloud_done_outlined, context.l10n.authBenefitSync),
          const SizedBox(height: 8),
          _buildBenefitRow(context, Icons.backup_outlined, context.l10n.authBenefitBackup),
          const SizedBox(height: 8),
          _buildBenefitRow(context, Icons.workspace_premium_outlined, context.l10n.authBenefitPremium),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: context.theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Column(
      children: [
        // Botón de Google
        _SocialAuthButton(
          label: context.l10n.authContinueWithGoogle,
          iconPath: 'assets/icons/google_logo.png',
          fallbackIcon: Icons.g_mobiledata_rounded,
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).signInWithGoogle();
            
            // Solo manejamos errores en la vista. La navegación la hace GoRouter.
            final state = ref.read(authControllerProvider);
            if (state.hasError && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error.toString())),
              );
            }
          },
        ),
        const SizedBox(height: 12),

        // Botón de Apple (Solo visible en iOS/macOS)
        if (Platform.isIOS || Platform.isMacOS) ...[
          _SocialAuthButton(
            label: context.l10n.authContinueWithApple,
            iconPath: 'assets/icons/apple_logo.png',
            fallbackIcon: Icons.apple,
            isDarkBg: true,
            onPressed: () {
              ref.read(authControllerProvider.notifier).signInWithApple();
            },
          ),
          const SizedBox(height: 12),
        ],

        // Botón Modo Invitado
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            side: BorderSide(
              color: context.cozy.inkColor?.withValues(alpha: 0.2) ?? Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          onPressed: () async {
            await ref.read(preferencesServiceProvider).setGuestMode(true);
            await ref.read(authControllerProvider.notifier).continueAsGuest();
            // 2. Navegar al Home
            if (context.mounted) {
              context.go('/');
            }
          },
          child: Text(
            context.l10n.authContinueAsGuest,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final IconData fallbackIcon;
  final bool isDarkBg;
  final VoidCallback onPressed;

  const _SocialAuthButton({
    required this.label,
    required this.iconPath,
    required this.fallbackIcon,
    this.isDarkBg = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkBg ? Colors.black : context.theme.cardColor;
    final textColor = isDarkBg ? Colors.white : context.theme.textTheme.bodyLarge?.color;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isDarkBg
          ? BorderSide.none
          : BorderSide(
              color: context.cozy.inkColor?.withValues(alpha: 0.15) ?? Colors.grey.withValues(alpha: 0.2),
            ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 20,
            width: 20,
            errorBuilder: (_, _, _) => Icon(
              fallbackIcon,
              size: 22,
              color: textColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}