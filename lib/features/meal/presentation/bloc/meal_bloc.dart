import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/features/meal/domain/repositories/meal_repository.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_event.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository mealRepository;

  int _listFetchGeneration = 0;

  MealBloc({required this.mealRepository}) : super(MealInitial()) {
    on<MealFetchStarted>(_onMealFetchStarted);
    on<MealFetchByIdStarted>(_onMealFetchByIdStarted);
  }

  Future<void> _onMealFetchStarted(
    MealFetchStarted event,
    Emitter<MealState> emit,
  ) async {
    final generation = ++_listFetchGeneration;
    emit(MealLoading());

    try {
      final meals = await mealRepository.getMeals();
      if (generation != _listFetchGeneration) return;

      if (meals.isEmpty) {
        emit(MealEmpty());
      } else {
        emit(MealSuccess(meals: meals));
      }
    } on ServerException catch (e) {
      if (generation != _listFetchGeneration) return;
      emit(MealError(message: e.message));
    } catch (e) {
      if (generation != _listFetchGeneration) return;
      emit(MealError(message: e.toString()));
    }
  }

  Future<void> _onMealFetchByIdStarted(
    MealFetchByIdStarted event,
    Emitter<MealState> emit,
  ) async {
    emit(MealLoading());
    try {
      final meal = await mealRepository.getMealById(event.mealId);
      emit(MealDetailSuccess(meal: meal));
    } on ServerException catch (e) {
      emit(MealError(message: e.message));
    } catch (e) {
      emit(MealError(message: e.toString()));
    }
  }
}
