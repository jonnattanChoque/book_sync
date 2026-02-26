import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/src/data/quote_repository.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

enum BookmarkStatus { hidden, visible, peek }

class BookmarkNotifier extends StateNotifier<BookmarkStatus> {
  final Isar _isar;

  BookmarkNotifier(this._isar) : super(BookmarkStatus.hidden) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      _handleDailyAnimation();
    });
  }

  Future<void> _handleDailyAnimation() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final configCollection = _isar.collection<AppConfig>();
    final config = await configCollection.where().findFirst();

    if (config?.lastBookmarkAnimDate == today) {
      state = BookmarkStatus.peek;
    } else {
      final repo = QuoteRepository();
      final newQuote = await repo.getRandomQuote();

      await showSequence();
      await _isar.writeTxn(() async {
        final update = config ?? AppConfig();
        update.lastBookmarkAnimDate = today;
        update.dailyQuoteText = newQuote.text;
        update.dailyQuoteAuthor = newQuote.author;
        await configCollection.put(update);
      });
    }
  }

  Future<void> showSequence() async {
    state = BookmarkStatus.hidden;
    await Future.delayed(const Duration(milliseconds: 500));
    state = BookmarkStatus.visible; 
    await Future.delayed(const Duration(seconds: 4));
    state = BookmarkStatus.peek; 
  }

  void toggle() {
    state = (state == BookmarkStatus.visible) 
        ? BookmarkStatus.peek 
        : BookmarkStatus.visible;
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, BookmarkStatus>((ref) {
  final isar = ref.watch(isarProvider);
  return BookmarkNotifier(isar);
});