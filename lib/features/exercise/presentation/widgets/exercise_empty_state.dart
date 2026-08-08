import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class ExerciseEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const ExerciseEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: ColorConstants.buttonTextColor.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorConstants.buttonColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: ColorConstants.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sports_gymnastics_rounded,
                    color: ColorConstants.buttonTextColor,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'no_exercises_found'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ColorConstants.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'empty_exercises'.tr(),
              style: const TextStyle(
                fontSize: 14,
                color: ColorConstants.textSecondaryColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 32),
              _GradientActionButton(
                label: 'refresh'.tr(),
                icon: Icons.refresh_rounded,
                onPressed: onRefresh!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        color: ColorConstants.buttonColor,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.buttonColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: ColorConstants.buttonTextColor),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: ColorConstants.buttonTextColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.transparent,
          shadowColor: ColorConstants.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}
