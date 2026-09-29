import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BookLoader extends StatelessWidget {
  final double size;

  const BookLoader({
    super.key,
    this.size = 240.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/book_loading.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}