import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
              _buildTab(context, null, "All"),
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
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey.shade100,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
