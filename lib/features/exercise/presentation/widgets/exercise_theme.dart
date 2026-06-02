import 'package:flutter/material.dart';

/// Presentation-only styling constants for the exercise feature.
abstract final class ExerciseTheme {
  ExerciseTheme._();

  static const gradientStart = Color(0xFF92A3FD);
  static const gradientEnd = Color(0xFF9DCEFF);

  static const gradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardRadius = 24.0;
  static const chipRadius = 12.0;
  static const horizontalPadding = 16.0;
  static const listBottomPadding = 24.0;

  static BoxDecoration cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
