import 'package:equatable/equatable.dart';
import 'package:fit_me/features/meal/domain/entities/meal_type.dart';

class MealEntity extends Equatable {
  final int mealId;
  final String name;
  final int calories;
  final List<String> ingredients;
  final MealType mealType;
  final String? url;

  const MealEntity({
    required this.mealId,
    required this.name,
    required this.calories,
    required this.ingredients,
    required this.mealType,
    this.url,
  });

  MealEntity copyWith({
    final int? mealId,
    final String? name,
    final int? calories,
    final List<String>? ingredients,
    final MealType? mealType,
    final String? url,
  }) {
    return MealEntity(
      mealId: mealId ?? this.mealId,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      mealType: mealType ?? this.mealType,
      url: url ?? this.url,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    mealId,
    name,
    calories,
    ingredients,
    mealType,
    url,
  ];
}
