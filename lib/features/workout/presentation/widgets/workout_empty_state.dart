import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class WorkoutEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const WorkoutEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Glowing visual badge
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: ColorConstants.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Text Content
            Text(
              "workout_empty_state_title".tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "workout_empty_state_message".tr(),
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 32),
              // Refresh Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: ColorConstants.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: ColorConstants.buttonTextColor,
                  ),
                  label: Text(
                    "refresh".tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.buttonTextColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.transparent,
                    shadowColor: ColorConstants.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
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
