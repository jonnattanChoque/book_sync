import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/bookmark_clipper.dart';
import 'package:book_sync/src/features/quotes/presentation/bookmark_provider.dart';
import 'package:book_sync/src/features/quotes/presentation/daily_quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyQuoteBookmark extends ConsumerWidget {
  const DailyQuoteBookmark({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cozyColors = Theme.of(context).extension<CozyColors>();
    final status = ref.watch(bookmarkProvider);
    final quoteAsync = ref.watch(dailyQuoteProvider);
    const double hiddenPos = -350.0;

    double rightPosition;
    switch (status) {
      case BookmarkStatus.visible:
        rightPosition = 0;
        break;
      case BookmarkStatus.peek:
        rightPosition = -310;
        break;
      case BookmarkStatus.hidden:
        rightPosition = hiddenPos;
        break;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      right: rightPosition - 5,
      top: 100,
      child: GestureDetector(
        onTap: () => ref.read(bookmarkProvider.notifier).toggle(),
        child: ClipPath(
          clipper: BookmarkClipper(),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 350,
              minHeight: 80, 
              maxHeight: 100,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: cozyColors?.bookmarkColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topRight: Radius.zero,
                bottomRight: Radius.zero,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.prussianBlue.withValues(alpha: 0.8),
                  blurRadius: 3,
                  offset: const Offset(-4, 6),
                ),
              ],
            ),
            child: Row( 
              children: [
                const SizedBox(width: 28),
                Flexible(
                  child: quoteAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => Text(
                      "Error",
                      style: GoogleFonts.specialElite(color: Colors.white70, fontSize: 12),
                    ),
                    data: (quote) => Text(
                      '"${quote.text} (${quote.book}, ${quote.author})"',
                      style: GoogleFonts.specialElite(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        height: 1.2,
                      ),
                      maxLines: 3, 
                      overflow: TextOverflow.ellipsis,
                    ),
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