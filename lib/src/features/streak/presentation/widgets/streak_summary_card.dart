// lib/src/features/reading/presentation/widgets/streak_summary_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StreakSummaryCard extends StatefulWidget {
  final int previousStreak;
  final int currentStreak;
  final Duration autoHideDuration;

  const StreakSummaryCard({
    super.key,
    required this.previousStreak,
    required this.currentStreak,
    this.autoHideDuration = const Duration(seconds: 4),
  });

  @override
  State<StreakSummaryCard> createState() => _StreakSummaryCardState();
}

class _StreakSummaryCardState extends State<StreakSummaryCard>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _exitController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _exitFadeAnimation;
  late Animation<Offset> _exitSlideAnimation;

  Timer? _autoHideTimer;
  bool _isOpaqueHidden = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 65,
      ),
    ]).animate(_entryController);

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeInOut,
      ),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _exitSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.2, 0.0),
    ).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeIn),
    );

    _entryController.forward();

    _startAutoHideTimer();
  }

  void _startAutoHideTimer() {
    _autoHideTimer = Timer(widget.autoHideDuration, () async {
      if (mounted) {
        await _exitController.forward();
        setState(() {
          _isOpaqueHidden = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOpaqueHidden) return const SizedBox.shrink();
    final isStreakIncreased = widget.currentStreak > widget.previousStreak;

    return SlideTransition(
      position: _exitSlideAnimation,
      child: FadeTransition(
        opacity: _exitFadeAnimation,
        child: AnimatedBuilder(
          animation: _entryController,
          builder: (context, child) {
            final double progress = _glowAnimation.value.clamp(0.0, 1.0);
            final displayStreak = (_entryController.value > 0.4 && isStreakIncreased)
              ? widget.currentStreak
              : widget.previousStreak;

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color.lerp(
                    context.cozy.inkColor!.withValues(alpha: 0.2),
                    Colors.orangeAccent,
                    progress * 0.5,
                  )!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.15 * progress),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Ícono del Fuego Animado
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange.withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        size: 36,
                        color: Color.lerp(
                          Colors.grey,
                          Colors.deepOrangeAccent,
                          progress,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Textos e Incremento Animado
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isStreakIncreased
                              ? context.l10n.streakIncreased
                              : context.l10n.streakCurrent,
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: Text(
                            context.l10n.streakDaysCount(displayStreak),
                            key: ValueKey<int>(displayStreak),
                            style: context.theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}