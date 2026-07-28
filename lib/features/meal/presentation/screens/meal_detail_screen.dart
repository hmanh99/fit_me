import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
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
              color: const Color(0xFF92A3FD),
              backgroundColor: Colors.white,
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
              color: Colors.black.withValues(alpha: 0.04),
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
        color: ColorConstants.icon,
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
            color: ColorConstants.primaryTextColor,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9B70).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Color(0xFFFF9B70),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${meal.calories} kcal",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryTextColor,
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
        const Text(
          "Ingredients Needed",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 12),
        if (meal.ingredients.isEmpty)
          const Text(
            "No ingredients listed.",
            style: TextStyle(
              color: ColorConstants.secondaryTextColor,
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
        return const Color(0xFF92A3FD);
      case MealType.lunch:
        return const Color(0xFFC58BF2);
      case MealType.dinner:
        return const Color(0xFFFF9B70);
    }
  }
}
