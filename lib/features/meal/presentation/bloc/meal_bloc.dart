import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meal_by_id_use_case.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meals_use_case.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_event.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final GetMealsUseCase _getMeals;
  final GetMealByIdUseCase _getMealById;

  int _listFetchGeneration = 0;

  MealBloc({
    required GetMealsUseCase getMeals,
    required GetMealByIdUseCase getMealById,
  })  : _getMeals = getMeals,
        _getMealById = getMealById,
        super(MealInitial()) {
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
      final meals = await _getMeals();
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
      final meal = await _getMealById(event.mealId);
      emit(MealDetailSuccess(meal: meal));
    } on ServerException catch (e) {
      emit(MealError(message: e.message));
    } catch (e) {
      emit(MealError(message: e.toString()));
    }
  }
}
