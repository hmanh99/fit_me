import 'package:easy_localization/easy_localization.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';
import 'package:fit_me/features/workout/presentation/widgets/exercise_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class _ConfiguredExerciseItem {
  final int exerciseId;
  final String name;
  final List<String> muscleGroups;
  int targetSets;
  int targetRepsOrSeconds;

  _ConfiguredExerciseItem({
    required this.exerciseId,
    required this.name,
    required this.muscleGroups,
    this.targetSets = 3,
    this.targetRepsOrSeconds = 12,
  });
}

class CreateEditPlanScreen extends StatefulWidget {
  final WorkoutPlanEntity? initialPlan;

  const CreateEditPlanScreen({super.key, this.initialPlan});

  @override
  State<CreateEditPlanScreen> createState() => _CreateEditPlanScreenState();
}

class _CreateEditPlanScreenState extends State<CreateEditPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final List<_ConfiguredExerciseItem> _exercises = [];

  bool get isEditMode => widget.initialPlan != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialPlan?.planName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialPlan?.description ?? '',
    );

    if (widget.initialPlan != null) {
      for (final planEx in widget.initialPlan!.planExercises) {
        _exercises.add(
          _ConfiguredExerciseItem(
            exerciseId: planEx.exerciseId,
            name: planEx.exerciseName,
            muscleGroups: planEx.musclesGroup,
            targetSets: planEx.targetSets,
            targetRepsOrSeconds: planEx.targetRepsOrSeconds,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openExercisePicker() async {
    final alreadySelected = _exercises.map((e) => e.exerciseId).toList();
    final selected = await ExercisePickerSheet.show(
      context,
      alreadySelectedIds: alreadySelected,
    );

    if (selected != null && selected.isNotEmpty) {
      setState(() {
        for (final ex in selected) {
          final rawId = ex['exercise_id'];
          final exerciseId = rawId is int
              ? rawId
              : int.tryParse(rawId?.toString() ?? '') ?? 0;
          final name = (ex['name'] as String?) ?? '';
          final muscleGroups = List<String>.from(ex['muscles_group'] ?? []);

          if (!_exercises.any((e) => e.exerciseId == exerciseId)) {
            _exercises.add(
              _ConfiguredExerciseItem(
                exerciseId: exerciseId,
                name: name,
                muscleGroups: muscleGroups,
                targetSets: 3,
                targetRepsOrSeconds: 12,
              ),
            );
          }
        }
      });
    }
  }

  void _savePlan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_add_at_least_one_exercise'.tr()),
          backgroundColor: ColorConstants.snackBarFailedColor,
        ),
      );
      return;
    }

    final authServices = AuthServices();
    final userId = authServices.user?.id;

    final planExercises = _exercises.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value;
      return PlanExerciseEntity(
        planExerciseId: 0,
        planId: widget.initialPlan?.planId ?? 0,
        exerciseId: item.exerciseId,
        orderInWorkout: idx + 1,
        targetSets: item.targetSets,
        targetRepsOrSeconds: item.targetRepsOrSeconds,
        exerciseName: item.name,
        musclesGroup: item.muscleGroups,
      );
    }).toList();

    final planEntity = WorkoutPlanEntity(
      planId: widget.initialPlan?.planId ?? 0,
      userId: userId,
      planName: _nameController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      createdAt: widget.initialPlan?.createdAt ?? DateTime.now(),
      planExercises: planExercises,
    );

    if (isEditMode) {
      context.read<WorkoutBloc>().add(
        WorkoutUpdatePlanStarted(plan: planEntity),
      );
    } else {
      context.read<WorkoutBloc>().add(
        WorkoutCreatePlanStarted(plan: planEntity),
      );
    }
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
          final authServices = AuthServices();
          final userId = authServices.user?.id;
          context.read<WorkoutBloc>().add(
            WorkoutFetchPlansStarted(userId: userId),
          );
          context.pop();
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
        final isLoading = state is WorkoutPlanActionInProgress;

        return Scaffold(
          backgroundColor: ColorConstants.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: ColorConstants.appBarForegroundColor,
              onPressed: () => context.pop(),
            ),
            title: Text(
              isEditMode ? 'edit_plan_title'.tr() : 'create_plan_title'.tr(),
              style: const TextStyle(
                color: ColorConstants.appBarForegroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            toolbarHeight: 64,
            elevation: 0,
            backgroundColor: ColorConstants.appBarBackgroundColor,
            centerTitle: true,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Plan info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConstants.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'plan_info_section'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Plan Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'plan_name_label'.tr(),
                          hintText: 'plan_name_hint'.tr(),
                          prefixIcon: const Icon(
                            Icons.fitness_center_rounded,
                            color: ColorConstants.primaryColor,
                          ),
                          filled: true,
                          fillColor: ColorConstants.greyShade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.greyShade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.greyShade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'plan_name_required'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'plan_description_label'.tr(),
                          hintText: 'plan_description_hint'.tr(),
                          alignLabelWithHint: true,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Icon(
                              Icons.notes_rounded,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                          filled: true,
                          fillColor: ColorConstants.greyShade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.greyShade400,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.greyShade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: ColorConstants.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'exercises_in_plan'.tr(
                        namedArgs: {'count': _exercises.length.toString()},
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textPrimaryColor,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _openExercisePicker,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text('add_exercises_btn'.tr()),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorConstants.primaryColor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                if (_exercises.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.playlist_add_rounded,
                            size: 32,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'no_exercises_in_plan_yet'.tr(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'tap_add_exercises_hint'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: ColorConstants.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _openExercisePicker,
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text('add_exercises_btn'.tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.primaryColor,
                            foregroundColor: ColorConstants.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    itemCount: _exercises.length,
                    onReorder: _onReorderExercises,
                    itemBuilder: (context, index) {
                      return _buildExerciseConfigCard(_exercises[index], index);
                    },
                  ),

                const SizedBox(height: 80),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorConstants.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _savePlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.buttonColor,
                    foregroundColor: ColorConstants.buttonTextColor,
                    disabledBackgroundColor: ColorConstants.greyShade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: ColorConstants.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          isEditMode
                              ? 'update_plan_btn'.tr()
                              : 'save_plan_btn'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onReorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, item);
    });
  }

  Widget _buildExerciseConfigCard(_ConfiguredExerciseItem item, int index) {
    return Container(
      key: ValueKey(item.exerciseId),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: ColorConstants.greyShade200),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.drag_handle_rounded,
                color: ColorConstants.textSecondaryColor,
              ),
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: ColorConstants.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textPrimaryColor,
                  ),
                ),
                if (item.muscleGroups.isNotEmpty)
                  Text(
                    item.muscleGroups.join(', '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.textSecondaryColor,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: ColorConstants.errorColor,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _exercises.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }
}
