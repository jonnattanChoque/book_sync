import 'dart:convert';
import 'dart:math';
import 'package:book_sync/core/constants/app_assets.dart';
import 'package:flutter/services.dart';
import '../domain/quote.dart';

class QuoteRepository {
  Future<Quote> getRandomQuote() async {
    final String response = await rootBundle.loadString(AppAssets.bookmarkDaily);
    final List<dynamic> data = json.decode(response);
    final randomIndex = Random().nextInt(data.length);
    
    return Quote.fromJson(data[randomIndex]);
  }
}