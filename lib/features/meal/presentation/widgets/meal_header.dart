import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_type.dart';

class MealHeader extends StatelessWidget {
  final MealType? selectedType;
  final ValueChanged<MealType?> onTypeSelected;

  const MealHeader({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter tabs
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildTab(context, null, "all".tr()),
              const SizedBox(width: 12),
              _buildTab(context, MealType.breakfast, "breakfast".tr()),
              const SizedBox(width: 12),
              _buildTab(context, MealType.lunch, "lunch".tr()),
              const SizedBox(width: 12),
              _buildTab(context, MealType.dinner, "dinner".tr()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, MealType? type, String label) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? ColorConstants.iconColor : ColorConstants.textSecondaryColor.withValues(alpha: 0.2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ColorConstants.buttonTextColor : ColorConstants.textSecondaryColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
