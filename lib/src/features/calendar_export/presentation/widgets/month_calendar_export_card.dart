import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthCalendarExportCard extends StatelessWidget {
  final DateTime month;
  final int totalPages;
  final int totalBooksRead;
  final int activeDaysCount;

  const MonthCalendarExportCard({
    super.key,
    required this.month,
    required this.totalPages,
    required this.totalBooksRead,
    required this.activeDaysCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final monthName = DateFormat.yMMMM(Localizations.localeOf(context).toString()).format(month);

    return Container(
      width: 320,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(context),
          const SizedBox(height: 16),
          Text(
            monthName.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(
                label: 'Páginas',
                value: '$totalPages',
              ),
              _MetricItem(
                label: 'Días leídos',
                value: '$activeDaysCount',
              ),
              _MetricItem(
                label: 'Libros',
                value: '$totalBooksRead',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 24,
            height: 24,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.calendarTitle.toUpperCase(),
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}


class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}