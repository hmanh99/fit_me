import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_names.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_error_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_exercise_card.dart';
import 'package:fit_me/features/workout/presentation/widgets/workout_loading_skeleton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final int workoutId;
  final String? planName;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
    this.planName,
  });

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late String _planName;

  @override
  void initState() {
    super.initState();
    _planName = widget.planName ?? 'workout_plan'.tr();
    _fetchDetails();
  }

  void _fetchDetails() {
    context.read<WorkoutBloc>().add(
      WorkoutFetchPlanDetailsStarted(planId: widget.workoutId),
    );
  }

  void _confirmDelete(WorkoutPlanEntity plan) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ColorConstants.dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'delete_plan_confirm_title'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'delete_plan_confirm_msg'.tr(namedArgs: {'name': plan.planName}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: ColorConstants.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                final userId = Supabase.instance.client.auth.currentUser?.id;
                context.read<WorkoutBloc>().add(
                  WorkoutDeletePlanStarted(planId: plan.planId, userId: userId),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.deleteActionColor,
                foregroundColor: ColorConstants.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('delete'.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(context.locale);
    return BlocConsumer<WorkoutBloc, WorkoutState>(
      listener: (context, state) {
        if (state is WorkoutPlanActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message.tr()),
              backgroundColor: ColorConstants.snackBarSuccessColor,
            ),
          );
          // Refresh list for user and navigate back
          final userId = Supabase.instance.client.auth.currentUser?.id;
          context.read<WorkoutBloc>().add(WorkoutFetchPlansStarted(userId: userId));
          context.goNamed(AppRouteNames.appWorkouts);
        } else if (state is WorkoutPlanDetailsLoaded) {
          setState(() {
            _planName = state.workoutPlan.planName;
          });
        } else if (state is WorkoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorConstants.snackBarFailedColor,
            ),
          );
        }
      },
      builder: (context, state) {
        WorkoutPlanEntity? loadedPlan;
        if (state is WorkoutPlanDetailsLoaded) {
          loadedPlan = state.workoutPlan;
        }

        final isOwner = loadedPlan != null && !loadedPlan.isDefaultPlan;

        return Scaffold(
          backgroundColor: ColorConstants.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: ColorConstants.appBarForegroundColor,
              onPressed: () {
                context.goNamed(AppRouteNames.appWorkouts);
              },
            ),
            title: Text(
              _planName,
              style: const TextStyle(
                color: ColorConstants.appBarForegroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            toolbarHeight: 64,
            elevation: 0,
            backgroundColor: ColorConstants.appBarBackgroundColor,
            actions: isOwner
                ? [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded),
                      color: ColorConstants.appBarForegroundColor,
                      tooltip: 'edit_plan_btn'.tr(),
                      onPressed: () async {
                        await context.pushNamed(
                          AppRouteNames.appEditPlan,
                          extra: loadedPlan,
                        );
                        _fetchDetails();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: ColorConstants.appBarForegroundColor,
                      tooltip: 'delete_plan_btn'.tr(),
                      onPressed: () => _confirmDelete(loadedPlan!),
                    ),
                  ]
                : null,
          ),
          body: _buildBody(state),
          bottomNavigationBar: _buildBottomBar(loadedPlan),
        );
      },
    );
  }

  Widget _buildBody(WorkoutState state) {
    if (state is WorkoutLoading || state is WorkoutPlanActionInProgress) {
      return const WorkoutLoadingSkeleton(isDetailPage: true);
    } else if (state is WorkoutError) {
      return WorkoutErrorState(
        errorMessage: state.message,
        onRetry: _fetchDetails,
      );
    } else if (state is WorkoutPlanDetailsLoaded) {
      final plan = state.workoutPlan;
      return RefreshIndicator(
        onRefresh: () async => _fetchDetails(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(plan),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  'exercises_list_title'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: plan.planExercises.length,
                  itemBuilder: (context, index) {
                    final planEx = plan.planExercises[index];
                    return TweenAnimationBuilder<double>(
                      key: ValueKey(planEx.planExerciseId),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(
                        milliseconds: 350 + (index * 60),
                      ),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: WorkoutExerciseCard(
                        planExercise: planEx,
                        onTap: () {
                          context.goNamed(
                            AppRouteNames.appWorkoutExerciseDetail,
                            pathParameters: {
                              'workoutId': plan.planId.toString().trim(),
                              'exerciseId': planEx.exerciseId
                                  .toString()
                                  .trim(),
                            },
                            queryParameters: {
                              'exerciseName': planEx.exerciseName
                                  .trim(),
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget? _buildBottomBar(WorkoutPlanEntity? plan) {
    if (plan == null || plan.planExercises.isEmpty) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              context.goNamed(
                AppRouteNames.appWorkoutSession,
                pathParameters: {'workoutId': plan.planId.toString()},
                extra: plan,
              );
            },
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: ColorConstants.buttonTextColor,
              size: 26,
            ),
            label: Text(
              'start_workout_button'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstants.buttonTextColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: ColorConstants.buttonColor,
              foregroundColor: ColorConstants.buttonTextColor,
              shadowColor: ColorConstants.buttonColor.withValues(
                alpha: 0.4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(WorkoutPlanEntity plan) {
    final totalSets = plan.planExercises.fold<int>(
      0,
      (sum, item) => sum + item.targetSets,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ColorConstants.borderLightColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan.planName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textPrimaryColor,
            ),
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              plan.description!,
              style: const TextStyle(
                fontSize: 13,
                color: ColorConstants.textSecondaryColor,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Statistics row
          Row(
            children: [
              _buildStatChip(
                icon: Icons.fitness_center_rounded,
                label: 'exercises_count'.tr(
                  namedArgs: {'count': plan.exerciseCount.toString()},
                ),
                color: ColorConstants.iconColor,
              ),
              const SizedBox(width: 12),
              _buildStatChip(
                icon: Icons.repeat_rounded,
                label: 'total_sets'.tr(
                  namedArgs: {'count': totalSets.toString()},
                ),
                color: ColorConstants.iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
