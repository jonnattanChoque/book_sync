// ignore_for_file: camel_case_types

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/utils/date_formatter.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(checkStreakInactivityProvider)();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _homeTitle(),
          const _calendarStamp(),
        ],
      ),
    );
  }
}

class _homeTitle extends StatelessWidget {
  const _homeTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.welcomeTitle,
          style: context.theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.welcomeMessage,
          style: context.theme.textTheme.headlineMedium?.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _calendarStamp extends StatefulWidget {
  const _calendarStamp();

  @override
  State<_calendarStamp> createState() => _CalendarStampState();
}

class _CalendarStampState extends State<_calendarStamp> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cozy = CozyColors.of(context);
    final today = DateTime.now();
    final dateString = DateFormatter.getHomeDate(today);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        context.push('/calendar');
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedRotation(
          turns: _isPressed ? 0 : -0.015,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isPressed 
                  ? cozy.inkColor!.withValues(alpha: 0.05) 
                  : Colors.transparent,
              border: Border.all(
                color: _isPressed 
                    ? cozy.inkColor!.withValues(alpha: 0.6) 
                    : cozy.inkColor!.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: _isPressed ? [] : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: cozy.inkColor,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  dateString,
                  style: GoogleFonts.specialElite(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cozy.inkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}