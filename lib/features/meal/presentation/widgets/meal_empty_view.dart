import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class MealEmptyView extends StatelessWidget {
  final VoidCallback? onRefresh;

  const MealEmptyView({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // visual badge
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: ColorConstants.iconColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: ColorConstants.iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: ColorConstants.iconColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: ColorConstants.buttonTextColor,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Text Content
            Text(
              "no_meals_found".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "empty_meal".tr(),
              style: TextStyle(fontSize: 14, color: ColorConstants.textSecondaryColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              // Refresh Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: ColorConstants.iconColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.iconColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded, color: ColorConstants.buttonTextColor),
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
