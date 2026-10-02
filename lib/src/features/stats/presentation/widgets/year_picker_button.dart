import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearCupertinoPickerButton extends StatelessWidget {
  final int selectedYear;
  final List<int> availableYears;
  final ValueChanged<int> onYearChanged;

  const YearCupertinoPickerButton({
    super.key,
    required this.selectedYear,
    required this.availableYears,
    required this.onYearChanged,
  });

  void _showCupertinoPicker(BuildContext context) {
    final years = availableYears.isNotEmpty
        ? availableYears
        : [DateTime.now().year];
    
    final initialIndex = years.indexOf(selectedYear).clamp(0, years.length - 1);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return SizedBox(
          height: 260,
          child: Column(
            children: [
              // Encabezado del modal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.statsSelectYearTitle,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.close_rounded),
                      onPressed: () {
                        final navigator = Navigator.of(modalContext);
                        if (navigator.canPop()) {
                          navigator.pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // CupertinoPicker de scroll continuo
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  onSelectedItemChanged: (int index) {
                    onYearChanged(years[index]);
                  },
                  children: years
                      .map(
                        (year) => Center(
                          child: Text(
                            year.toString(),
                            style: context.theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCupertinoPicker(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: context.theme.cardColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.cozy.bookmarkColor!.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedYear.toString(),
              style: context.theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cozy.bookmarkColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.unfold_more_rounded,
              size: 16,
              color: context.cozy.bookmarkColor,
            ),
          ],
        ),
      ),
    );
  }
}