import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/exercise/presentation/bloc/exercise_bloc.dart';
import 'package:fit_me/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:fit_me/features/exercise/presentation/bloc/exercise_state.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_detail_header.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_error_state.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_app_bar.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_info_section.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_instruction_list.dart';
import 'package:fit_me/features/exercise/presentation/widgets/exercise_loading_skeleton.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseBloc>().add(
      ExerciseFetchByIdStarted(exerciseId: widget.exerciseId),
    );
  }

  void _fetchExercise() {
    context.read<ExerciseBloc>().add(
      ExerciseFetchByIdStarted(exerciseId: widget.exerciseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.setLocale(context.locale);
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: ExerciseAppBar(
        title: 'exercise_detail'.tr(),
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return const ExerciseLoadingSkeleton(isDetailPage: true);
          } else if (state is ExerciseError) {
            return ExerciseErrorState(
              errorMessage: state.message,
              onRetry: _fetchExercise,
            );
          } else if (state is ExerciseDetailSuccess) {
            final exercise = state.exercise;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExerciseBloc>().add(
                  ExerciseFetchByIdStarted(exerciseId: exercise.exerciseId),
                );
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).padding.bottom + 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          border: Border.all(color: ColorConstants.greyShade300),
                        ),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 200,
                        child: Hero(
                          tag: "exercise-image-${exercise.exerciseId}",
                          child: exercise.url == null
                              ? Icon(Icons.fitness_center_outlined, size: 50)
                              : Image.network(exercise.url!),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ExerciseDetailHeader(exercise: exercise),
                      const SizedBox(height: 16),
                      ExerciseInfoSection(
                        title: 'muscle_group'.tr(),
                        icon: Icons.accessibility_new_rounded,
                        items: exercise.musclesGroup,
                        chipAccentColor: ColorConstants.primaryColor,
                      ),
                      if (exercise.requiresEquipment) ...[
                        const SizedBox(height: 16),
                        ExerciseInfoSection(
                          chipAccentColor: ColorConstants.primaryColor,
                          title: 'equipment'.tr(),
                          icon: Icons.fitness_center_rounded,
                          items: exercise.equipments ?? [],
                        ),
                      ],
                      if (exercise.instructions.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ExerciseInstructionList(
                          instructions: exercise.instructions,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
          return const ExerciseLoadingSkeleton(isDetailPage: true,);
        },
      ),
    );
  }
}
