import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meal_by_id_use_case.dart';
import 'package:fit_me/features/meal/domain/usecases/get_meals_use_case.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_event.dart';
import 'package:fit_me/features/meal/presentation/bloc/meal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final GetMealsUseCase _getMeals;
  final GetMealByIdUseCase _getMealById;

  int _listFetchGeneration = 0;

  MealBloc({
    required GetMealsUseCase getMeals,
    required GetMealByIdUseCase getMealById,
  }) : _getMeals = getMeals,
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
      final result = await _getMeals(NoParams());
      if (generation != _listFetchGeneration) return;

      result.fold(
        (failure) => emit(MealError(message: failure.message)),
        (meals) => emit(MealSuccess(meals: meals)),
      );
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
      final result = await _getMealById(MealParams(id: event.mealId));
      result.fold(
            (failure) => emit(MealError(message: failure.message)),
            (meal) => emit(MealDetailSuccess(meal: meal)),
      );
    } on ServerException catch (e) {
      emit(MealError(message: e.message));
    } catch (e) {
      emit(MealError(message: e.toString()));
    }
  }
}
