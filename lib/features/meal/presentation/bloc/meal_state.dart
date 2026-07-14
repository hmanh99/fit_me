import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealSuccess extends MealState {
  final List<MealEntity> meals;

  const MealSuccess({required this.meals});

  @override
  List<Object?> get props => [meals];
}

class MealDetailSuccess extends MealState {
  final MealEntity meal;

  const MealDetailSuccess({required this.meal});

  @override
  List<Object?> get props => [meal];
}

class MealEmpty extends MealState {}

class MealError extends MealState {
  final String message;

  const MealError({required this.message});

  @override
  List<Object?> get props => [message];
}
