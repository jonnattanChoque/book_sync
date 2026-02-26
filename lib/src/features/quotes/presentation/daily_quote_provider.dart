import 'package:book_sync/src/data/quote_repository.dart';
import 'package:book_sync/src/domain/quote.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quoteRepositoryProvider = Provider((ref) => QuoteRepository());

final dailyQuoteProvider = FutureProvider<Quote>((ref) async {
  final repository = ref.watch(quoteRepositoryProvider);
  return await repository.getRandomQuote();
});