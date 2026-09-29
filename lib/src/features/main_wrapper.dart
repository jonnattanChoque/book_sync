import 'package:book_sync/src/features/quotes/presentation/widgets/bookmark_view.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  const MainWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundPaperTexture(),
          SafeArea(
            bottom: false,
            child: child,
          ),
          
          DailyQuoteBookmarkView(), 
        ],
      ),
    );
  }
}