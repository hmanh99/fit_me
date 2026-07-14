import 'package:equatable/equatable.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object?> get props => [];
}

class MealFetchStarted extends MealEvent {
  const MealFetchStarted();
}

class MealFetchByIdStarted extends MealEvent {
  final int mealId;

  const MealFetchByIdStarted({required this.mealId});

  @override
  List<Object?> get props => [mealId];
}
