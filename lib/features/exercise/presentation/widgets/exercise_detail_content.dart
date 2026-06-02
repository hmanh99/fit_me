import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_detail_header.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_info_section.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_instruction_list.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseDetailContent extends StatelessWidget {
  final ExerciseEntity exercise;

  const ExerciseDetailContent({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final horizontalInset = _horizontalInset(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalInset,
        16,
        horizontalInset,
        ExerciseTheme.listBottomPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExerciseDetailHeader(exercise: exercise),
              const SizedBox(height: 16),
              ExerciseInfoSection(
                title: 'Target Muscles',
                icon: Icons.accessibility_new_rounded,
                items: exercise.muscleGroups,
                chipAccentColor: const Color(0xFF7F77DD),
              ),
              if (exercise.requiresEquipment) ...[
                const SizedBox(height: 16),
                ExerciseInfoSection(
                  title: 'Equipment',
                  icon: Icons.fitness_center_rounded,
                  items: exercise.equipments ?? [],
                ),
              ],
              if (exercise.instructions.isNotEmpty) ...[
                const SizedBox(height: 16),
                ExerciseInstructionList(instructions: exercise.instructions),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _horizontalInset(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      return 24;
    }
    return ExerciseTheme.horizontalPadding;
  }
}
