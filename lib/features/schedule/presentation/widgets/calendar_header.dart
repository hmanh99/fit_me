import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Custom header for the calendar showing month/year with navigation arrows.
class CalendarHeader extends StatelessWidget {
  final DateTime focusedDate;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const CalendarHeader({
    super.key,
    required this.focusedDate,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthYear = DateFormat('MMMM yyyy').format(focusedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _arrowButton(
            icon: Icons.chevron_left_rounded,
            onTap: onLeftArrowTap,
            theme: theme,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              monthYear,
              key: ValueKey(monthYear),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          _arrowButton(
            icon: Icons.chevron_right_rounded,
            onTap: onRightArrowTap,
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _arrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
