import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingGoalsSection extends ConsumerStatefulWidget {
  const ReadingGoalsSection({super.key});

  @override
  ConsumerState<ReadingGoalsSection> createState() => _ReadingGoalsSectionState();
}

class _ReadingGoalsSectionState extends ConsumerState<ReadingGoalsSection> {
  late final TextEditingController _yearlyGoalController;
  late final TextEditingController _weeklyHoursGoalController;
  final _yearlyFocusNode = FocusNode();
  final _weeklyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);

    _yearlyFocusNode.addListener(_onFocusChange);
    _weeklyFocusNode.addListener(_onFocusChange);
    _yearlyGoalController = TextEditingController(text: settings.yearlyGoalBooks.toString());
    _weeklyHoursGoalController = TextEditingController(
      text: settings.weeklyGoalHours.toStringAsFixed(
        settings.weeklyGoalHours.truncateToDouble() == settings.weeklyGoalHours ? 0 : 1,
      ),
    );
  }

  @override
  void dispose() {
    _yearlyFocusNode.removeListener(_onFocusChange);
    _weeklyFocusNode.removeListener(_onFocusChange);
    _yearlyFocusNode.dispose();
    _weeklyFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Si ninguno de los dos campos tiene foco, guardamos y mostramos el toast
    if (!_yearlyFocusNode.hasFocus && !_weeklyFocusNode.hasFocus) {
      _saveGoals();
    }
  }

  void _saveGoals() {
    final yearlyText = _yearlyGoalController.text.trim();
    final weeklyText = _weeklyHoursGoalController.text.trim();

    final yearlyGoal = int.tryParse(yearlyText);
    final weeklyHours = double.tryParse(weeklyText);

    ref.read(appSettingsProvider.notifier).updateReadingGoals(
      yearlyGoalBooks: (yearlyGoal != null && yearlyGoal > 0) ? yearlyGoal : null,
      weeklyGoalHours: (weeklyHours != null && !weeklyHours.isNaN && weeklyHours > 0) ? weeklyHours : null,
    );

    CozyToast.showSuccess(context, title: context.l10n.goalsSaved);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final cozy = context.cozy;

    ref.listen(appSettingsProvider, (previous, next) {
      if (previous?.yearlyGoalBooks != next.yearlyGoalBooks) {
        _yearlyGoalController.text = next.yearlyGoalBooks.toString();
      }
      if (previous?.weeklyGoalHours != next.weeklyGoalHours) {
        _weeklyHoursGoalController.text = next.weeklyGoalHours.toStringAsFixed(
          next.weeklyGoalHours.truncateToDouble() == next.weeklyGoalHours ? 0 : 1,
        );
      }
    });

    return CustomInfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          _buiildTitle(cozy, context, theme),
          const SizedBox(height: 16),

          // Fila: Objetivo Anual (Libros)
          _buildCardyear(colorScheme, context, theme, cozy),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),

          // Fila: Objetivo Semanal (Horas)
          _buildCardHour(colorScheme, context, theme, cozy),
        ],
      ),
    );
  }

  Row _buiildTitle(CozyColors cozy, BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.emoji_events_outlined,
          size: 20,
          color: cozy.bookmarkColor,
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.goalsSection,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Row _buildCardyear(ColorScheme colorScheme, BuildContext context, ThemeData theme, CozyColors cozy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.auto_stories_outlined,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.yearlyGoal,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: TextField(
            controller: _yearlyGoalController,
            focusNode: _yearlyFocusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildCardHour(ColorScheme colorScheme, BuildContext context, ThemeData theme, CozyColors cozy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.weeklyHoursGoal,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: TextField(
            controller: _weeklyHoursGoalController,
            focusNode: _weeklyFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}