import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/entities/meal_type.dart';

class MealModel extends MealEntity {
  const MealModel({
    required super.mealId,
    required super.name,
    required super.calories,
    required super.ingredients,
    required super.mealType,
    super.url,
  });

  factory MealModel.fromEntity(MealEntity entity) {
    return MealModel(
      mealId: entity.mealId,
      name: entity.name,
      calories: entity.calories,
      ingredients: entity.ingredients,
      mealType: entity.mealType,
      url: entity.url,
    );
  }

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      mealId: (json['meal_id'] as num).toInt(),
      name: json['name'] as String,
      calories: (json['calories'] as num).toInt(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      mealType: MealType.fromString(json['meal_type'].toString()),
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_id': mealId,
      'name': name,
      'calories': calories,
      'ingredients': ingredients,
      'meal_type': mealType.toDbString(),
      'url': url,
    };
  }
}