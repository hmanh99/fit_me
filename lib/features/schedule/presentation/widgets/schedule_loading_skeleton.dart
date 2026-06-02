import 'package:flutter/material.dart';

/// A custom shimmering skeleton loader designed specifically for the Schedule screen.
/// Simulates the layout of the calendar header, grid, divider, and schedule items.
class ScheduleLoadingSkeleton extends StatefulWidget {
  const ScheduleLoadingSkeleton({super.key});

  @override
  State<ScheduleLoadingSkeleton> createState() => _ScheduleLoadingSkeletonState();
}

class _ScheduleLoadingSkeletonState extends State<ScheduleLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Calendar Header Skeleton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBox(width: 38, height: 38, radius: 12, color: highlightColor),
                      _buildBox(width: 120, height: 20, radius: 6, color: highlightColor),
                      _buildBox(width: 38, height: 38, radius: 12, color: highlightColor),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // 2. Calendar Grid Skeleton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Days of the week row skeleton
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          7,
                          (index) => _buildBox(width: 24, height: 12, radius: 4, color: highlightColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 5 rows of calendar cells
                      ...List.generate(5, (rowIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(7, (colIndex) {
                              // Make some cells highlighted or marked for visual variety
                              final isSelected = rowIndex == 2 && colIndex == 3;
                              final isToday = rowIndex == 1 && colIndex == 1;
                              if (isSelected) {
                                return _buildBox(
                                  width: 40,
                                  height: 40,
                                  radius: 20,
                                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                );
                              }
                              if (isToday) {
                                return Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: _buildBox(width: 16, height: 16, radius: 8, color: highlightColor),
                                  ),
                                );
                              }
                              return _buildBox(width: 32, height: 32, radius: 16, color: baseColor);
                            }),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Date Divider Skeleton
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    children: [
                      _buildBox(width: 140, height: 26, radius: 8, color: highlightColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBox(width: double.infinity, height: 1, radius: 0, color: baseColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Schedule Items List Skeleton (2 items)
                ...List.generate(2, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: highlightColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Status Icon box placeholder
                          _buildBox(width: 44, height: 44, radius: 12, color: highlightColor),
                          const SizedBox(width: 16),
                          // Content placeholders
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBox(width: 160, height: 16, radius: 4, color: highlightColor),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildBox(width: 70, height: 18, radius: 6, color: highlightColor),
                                    const SizedBox(width: 8),
                                    _buildBox(width: 90, height: 12, radius: 4, color: baseColor),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildBox(width: 110, height: 12, radius: 4, color: baseColor),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Action button placeholder
                          _buildBox(width: 24, height: 24, radius: 12, color: highlightColor),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBox({
    required double width,
    required double height,
    required double radius,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
        shape: radius == 999 ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}
