import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';

class MealConfirmationDialog extends StatelessWidget {
  final MealEntity meal;
  final VoidCallback onConfirm;

  const MealConfirmationDialog({
    super.key,
    required this.meal,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = _getMealTypeColor(meal.mealType);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon header
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: typeColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              "Log This Meal?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorConstants.secondaryTextColor,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "Would you like to log "),
                  TextSpan(
                    text: meal.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryTextColor,
                    ),
                  ),
                  const TextSpan(text: " to your "),
                  TextSpan(
                    text: meal.mealType.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                    ),
                  ),
                  const TextSpan(text: " log? This will add "),
                  TextSpan(
                    text: "${meal.calories} kcal",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryTextColor,
                    ),
                  ),
                  const TextSpan(text: " to your daily total."),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: ColorConstants.secondaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF92A3FD).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Log Meal",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMealTypeColor(dynamic mealType) {
    final typeStr = mealType.toString().split('.').last.toLowerCase();
    switch (typeStr) {
      case 'breakfast':
        return const Color(0xFF92A3FD);
      case 'lunch':
        return const Color(0xFFC58BF2);
      case 'dinner':
        return const Color(0xFFFF9B70);
      default:
        return const Color(0xFF92A3FD);
    }
  }
}
