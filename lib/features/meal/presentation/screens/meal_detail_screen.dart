import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_type.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_event.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/bloc/meal_state.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/widgets/meal_app_bar.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/widgets/meal_empty_view.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/widgets/meal_error_view.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/widgets/meal_item.dart';
import 'package:personal_fitness_tracker/features/meal/presentation/widgets/meal_loading_skeleton.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.mealId});

  final int mealId;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MealBloc>().add(MealFetchByIdStarted(mealId: widget.mealId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: MealAppBar(title: "Meal Detail", onBack: () => context.pop()),
      body: BlocBuilder<MealBloc, MealState>(
        builder: (context, state) {
          if (state is MealLoading) {
            return const MealLoadingSkeleton(isDetail: true);
          } else if (state is MealEmpty) {
            return MealEmptyView(
              onRefresh: () async => context.read<MealBloc>().add(
                MealFetchByIdStarted(mealId: widget.mealId),
              ),
            );
          } else if (state is MealError) {
            return MealErrorView(
              errorMessage: state.message,
              onRetry: () {
                context.read<MealBloc>().add(
                  MealFetchByIdStarted(mealId: widget.mealId),
                );
              },
            );
          } else if (state is MealDetailSuccess) {
            final meal = state.meal;
            final badgeColor = _getMealTypeColor(meal.mealType);
            return RefreshIndicator(
              onRefresh: () async => context.read<MealBloc>().add(
                MealFetchByIdStarted(mealId: widget.mealId),
              ),
              color: ColorConstants.buttonColor,
              backgroundColor: ColorConstants.white,
              child: _buildBody(context, meal, badgeColor),
            );
          }
          return const MealLoadingSkeleton(isDetail: true);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MealEntity meal, Color badgeColor) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageBanner(meal, badgeColor, 220),
          const SizedBox(height: 20),
          _buildHeaderSection(meal, badgeColor),
          const SizedBox(height: 16),
          _buildNutritionCard(meal, badgeColor),
          const SizedBox(height: 24),
          _buildIngredientsSection(meal),
        ],
      ),
    );
  }

  Widget _buildImageBanner(MealEntity meal, Color badgeColor, double height) {
    return Hero(
      tag: 'meal-image-${meal.mealId}',
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
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
    );
  }

  Widget _buildPlaceholderIcon() {
    return const Center(
      child: Icon(
        Icons.restaurant_rounded,
        color: ColorConstants.primaryColor,
        size: 60,
      ),
    );
  }

  Widget _buildHeaderSection(MealEntity meal, Color badgeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            meal.mealType.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          meal.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorConstants.textPrimaryColor,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionCard(MealEntity meal, Color badgeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ColorConstants.greyShade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorConstants.caloriesIconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: ColorConstants.caloriesIconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Calories",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${meal.calories} kcal",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(MealEntity meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ingredients_needed".tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:ColorConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        if (meal.ingredients.isEmpty)
          Text(
            "no_ingredients_listed".tr(),
            style: const TextStyle(
              color: ColorConstants.textSecondaryColor,
              fontSize: 14,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: meal.ingredients.length,
            itemBuilder: (context, index) {
              return MealItem(text: meal.ingredients[index]);
            },
          ),
      ],
    );
  }

  Color _getMealTypeColor(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return ColorConstants.mealBreakfastColor;
      case MealType.lunch:
        return ColorConstants.mealLunchColor;
      case MealType.dinner:
        return ColorConstants.mealDinnerColor;
    }
  }
}
