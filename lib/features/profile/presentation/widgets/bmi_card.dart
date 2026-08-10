import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';

class BmiCard extends StatelessWidget {
  const BmiCard({super.key, required this.bmi, required this.category});

  final double bmi;
  final String category;

  Color get _categoryColor {
    if (bmi < 18.5) return ColorConstants.bmiUnderweightColor; // Underweight
    if (bmi < 25) return ColorConstants.bmiNormalColor; // Normal
    if (bmi < 30) return ColorConstants.bmiOverweightColor; // Overweight
    return ColorConstants.bmiObeseColor; // Obese
  }

  String get _feedbackText {
    if (bmi < 18.5) {
      return "bmi_feedback_underweight".tr();
    }
    if (bmi < 25) {
      return "bmi_feedback_normal".tr();
    }
    if (bmi < 30) {
      return "bmi_feedback_overweight".tr();
    }
    return "bmi_feedback_obese".tr();
  }

  double get _indicatorPercent => ((bmi - 15) / 25).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final activeColor = _categoryColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'bmi_title'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.textPrimaryColor,
                  letterSpacing: 0.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                bmi.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: ColorConstants.black,
                  height: 1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'kg/m²',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.grey.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: ColorConstants.bmiGradientColors,
                      ),
                    ),
                  ),
                  Positioned(
                    left: (_indicatorPercent * totalWidth).clamp(
                      6,
                      totalWidth - 6,
                    ),
                    top: -3,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: ColorConstants.buttonTextColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: activeColor, width: 3.5),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '15',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textSecondaryColor,
                ),
              ),
              Text(
                '40',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textSecondaryColor,
                ),
              ),
            ],
          ),
          const Divider(
            height: 32,
            thickness: 1,
            color: ColorConstants.dividerColor,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: ColorConstants.iconColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _feedbackText,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: ColorConstants.textSecondaryColor.withValues(
                      alpha: 0.9,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
