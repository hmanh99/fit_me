import 'package:flutter/material.dart';

/// Builds dot markers for a calendar cell.
///
/// Shows 1–3 dots depending on the number of events on that day,
/// with a subtle scale animation.
class WorkoutMarker extends StatelessWidget {
  final int count;

  const WorkoutMarker({super.key, required this.count});

  static const _maxDots = 3;
  static const _dotSize = 6.0;
  static const _spacing = 2.0;

  // Colour palette for markers (matches fitness theme).
  static const _dotColors = [
    Color(0xFFFF9B52), // orange — primary workout colour
    Color(0xFF92A3FD), // blue/purple — secondary
    Color(0xFF4CD964), // green — done
  ];

  @override
  Widget build(BuildContext context) {
    final dotCount = count.clamp(0, _maxDots);
    if (dotCount == 0) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(dotCount, (i) {
          return Container(
            width: _dotSize,
            height: _dotSize,
            margin: EdgeInsets.only(
              left: i == 0 ? 0 : _spacing,
            ),
            decoration: BoxDecoration(
              color: _dotColors[i % _dotColors.length],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _dotColors[i % _dotColors.length].withValues(alpha: 0.4),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
