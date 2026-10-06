// lib/src/features/profile/presentation/screens/profile_screen.dart

import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/src/features/profile/presentation/widgets/logout_swipe_button.dart';
import 'package:book_sync/src/features/profile/presentation/widgets/reading_alarm_section.dart';
import 'package:book_sync/src/features/profile/presentation/widgets/reading_goals_section.dart';
import 'package:book_sync/src/features/profile/presentation/widgets/theme_and_language_section.dart';
import 'package:book_sync/src/features/profile/presentation/widgets/user_data_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: context.theme.scaffoldBackgroundColor,
        child: Stack(
          children: [
            // Textura de fondo persistente
            const Positioned.fill(
              child: BackgroundPaperTexture(),
            ),
      
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: _buildNavBar(context),
              body: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const UserDataSection(),
                  const SizedBox(height: 16),
                  const ThemeAndLanguageSection(),
                  const SizedBox(height: 16),
                  const ReadingAlarmSection(),
                  const SizedBox(height: 16),
                  const ReadingGoalsSection(),
                  const SizedBox(height: 16),
                  LogoutSwipeButton(),
                ],
              ),
            )
          ]
        )
      ),
    );
  }

  AppBar _buildNavBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(context.l10n.profileTitle, style: context.theme.textTheme.titleLarge),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) {
          final modalRoute = ModalRoute.of(context);
          // Evaluamos si la ruta actual del screen (no del picker) puede hacer pop
          final canPop = modalRoute?.canPop ?? false;

          if (!canPop) return const SizedBox.shrink();

          return IconButton(
            icon: Icon(
              AppIcons.back,
              color: context.theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // Si GoRouter maneja la pantalla principal:
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          );
        },
      )
    );
  }
}