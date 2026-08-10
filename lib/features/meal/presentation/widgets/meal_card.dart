import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';

class MealCard extends StatelessWidget {
  final MealEntity meal;
  final VoidCallback onTap;

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final badgeColor = _getMealTypeColor(meal.mealType);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: ColorConstants.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Meal Image with Hero animation
                Hero(
                  tag: 'meal-image-${meal.mealId}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: meal.url != null && meal.url!.isNotEmpty
                        ? Image.network(
                            meal.url!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(),
                          )
                        : _buildPlaceholderIcon(),
                  ),
                ),
                const SizedBox(width: 16),
                // Meal Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              meal.mealType.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Meal Name
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Calories Count
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: ColorConstants.caloriesIconColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${meal.calories} kcal',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow Action
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: ColorConstants.iconColor,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Center(
      child: Icon(
        Icons.restaurant_rounded,
        color: ColorConstants.iconColor,
        size: 32,
      ),
    );
  }

  Color _getMealTypeColor(dynamic mealType) {
    final typeStr = mealType.toString().split('.').last.toLowerCase();
    switch (typeStr) {
      case 'breakfast':
        return ColorConstants.mealBreakfastColor;
      case 'lunch':
        return ColorConstants.mealLunchColor;
      case 'dinner':
        return ColorConstants.mealDinnerColor;
      default:
        return ColorConstants.mealLunchColor;
    }
  }
}
