import 'package:easy_localization/easy_localization.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_names.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_empty_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_error_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_loading_skeleton.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_plan_card.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  void _fetchPlans() {
    final userId = AuthServices().user!.id;
    context.read<WorkoutBloc>().add(WorkoutFetchPlansStarted(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(context.locale);
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: ColorConstants.appBarForegroundColor,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'workout_plans'.tr(),
          style: const TextStyle(
            color: ColorConstants.appBarForegroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 64,
        elevation: 0,
        backgroundColor: ColorConstants.appBarBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
            color: ColorConstants.appBarForegroundColor,
            tooltip: 'create_plan_btn'.tr(),
            onPressed: () => context.pushNamed(AppRouteNames.appCreatePlan),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'create_workout_plan_fab',
        onPressed: () => context.pushNamed(AppRouteNames.appCreatePlan),
        backgroundColor: ColorConstants.buttonColor,
        foregroundColor: ColorConstants.buttonTextColor,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'create_plan_btn'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutPlanActionSuccess) {
            _fetchPlans();
          }
        },
        builder: (context, state) {
          if (state is WorkoutLoading) {
            return const WorkoutLoadingSkeleton(isDetailPage: false);
          } else if (state is WorkoutError) {
            return WorkoutErrorState(
              errorMessage: state.message,
              onRetry: _fetchPlans,
            );
          } else if (state is WorkoutEmpty) {
            return WorkoutEmptyState(
              onRefresh: _fetchPlans,
            );
          } else if (state is WorkoutPlansLoaded) {
            final plans = state.workoutPlans;
            return RefreshIndicator(
              onRefresh: () async => _fetchPlans(),
              color: ColorConstants.buttonColor,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 12,
                  bottom: MediaQuery.of(context).padding.bottom + 80,
                ),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return TweenAnimationBuilder<double>(
                    key: ValueKey(plan.planId),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 350 + (index * 60)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: WorkoutPlanCard(
                      plan: plan,
                      onTap: () => context.goNamed(
                        AppRouteNames.appWorkoutDetail,
                        pathParameters: {'workoutId': plan.planId.toString()},
                        queryParameters: {'planName': plan.planName},
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
