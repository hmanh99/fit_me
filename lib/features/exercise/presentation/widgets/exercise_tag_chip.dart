import 'package:flutter/material.dart';

class ExerciseTagChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color accentColor;

  const ExerciseTagChip({
    super.key,
    required this.label,
    this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
