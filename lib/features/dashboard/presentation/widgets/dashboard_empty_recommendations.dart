import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class DashboardEmptyRecommendations extends StatelessWidget {
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
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: ColorConstants.buttonTextColor,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              'no_exercises_found'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            Text(
              'no_exercises_message'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: ColorConstants.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (onRefresh != null) ...[
              const SizedBox(height: 24),
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
                  icon: const Icon(Icons.refresh_rounded, color: ColorConstants.buttonTextColor),
                  label: Text(
                    'refresh'.tr(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.buttonTextColor,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.transparent,
                    shadowColor: ColorConstants.transparent,
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