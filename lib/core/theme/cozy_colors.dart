import 'package:flutter/material.dart';

class CozyColors extends ThemeExtension<CozyColors> {
  final Color? bookmarkColor;
  final Color? inkColor;

  CozyColors({required this.bookmarkColor, required this.inkColor});
  
  static CozyColors of(BuildContext context) {
    return Theme.of(context).extension<CozyColors>()!;
  }

  @override
  CozyColors copyWith({Color? bookmarkColor, Color? inkColor}) => 
    CozyColors(
      bookmarkColor: bookmarkColor ?? this.bookmarkColor, 
      inkColor: inkColor ?? this.inkColor
    );

  @override
  CozyColors lerp(ThemeExtension<CozyColors>? other, double t) {
    if (other is! CozyColors) return this;
    return CozyColors(
      bookmarkColor: Color.lerp(bookmarkColor, other.bookmarkColor, t),
      inkColor: Color.lerp(inkColor, other.inkColor, t),
    );
  }
}