import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';

/// Shown in the Recommendations section when [DashboardEmpty] is emitted.
/// Matches the visual style of [MealEmptyView] and [DashboardRecommendationsError].
class DashboardEmptyRecommendations extends StatelessWidget {
  /// Called when the user taps the refresh button.
  final VoidCallback? onRefresh;

  const DashboardEmptyRecommendations({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Icon badge ────────────────────────────────────────────────
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Title ─────────────────────────────────────────────────────
            const Text(
              'No Exercises Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // ── Subtitle ──────────────────────────────────────────────────
            const Text(
              'We couldn\'t find any exercises to recommend right now. '
              'Tap Refresh to try again.',
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.secondaryTextColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // ── Retry button ──────────────────────────────────────────────
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  label: const Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
