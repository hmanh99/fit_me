import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/schedule_status.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

/// Bottom sheet for adding or editing a workout schedule entry.
///
/// When [existingSchedule] is provided, the form is pre-filled for editing.
class AddScheduleBottomSheet extends StatefulWidget {
  final WorkoutScheduleEntity? existingSchedule;

  const AddScheduleBottomSheet({super.key, this.existingSchedule});

  /// Show the bottom sheet from anywhere.
  static Future<void> show(
    BuildContext context, {
    WorkoutScheduleEntity? existingSchedule,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleBloc>(),
        child: AddScheduleBottomSheet(existingSchedule: existingSchedule),
      ),
    );
  }

  @override
  State<AddScheduleBottomSheet> createState() => _AddScheduleBottomSheetState();
}

class _AddScheduleBottomSheetState extends State<AddScheduleBottomSheet> {
  final _noteController = TextEditingController();
  final _planNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  ScheduleStatus _selectedStatus = ScheduleStatus.upcoming;
  WorkoutPlanEntity? _selectedPlan;
  bool _isCustomPlan = false;

  bool get _isEditing => widget.existingSchedule != null;

  @override
  void initState() {
    super.initState();

    // Schedule already exist
    if (_isEditing) {
      final s = widget.existingSchedule!;
      _selectedDate = s.scheduleDate;
      _selectedStatus = s.status;
      _noteController.text = s.note ?? '';
      _planNameController.text = s.planName;
      _isCustomPlan = true; // Pre-fill custom name for editing
    }

    // Fetch workout plans for the selector
    final userId = Supabase.instance.client.auth.currentUser?.id;
    context.read<WorkoutBloc>().add(WorkoutFetchPlansStarted(userId: userId));
  }

  @override
  void dispose() {
    _noteController.dispose();
    _planNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 24 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              _isEditing ? 'Edit Schedule' : 'Add Schedule',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            //     Workout Plan Selector
            Text(
              'Workout Plan',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<WorkoutBloc, WorkoutState>(
              builder: (context, workoutState) {
                if (workoutState is WorkoutLoading) {
                  return const LinearProgressIndicator();
                }

                List<WorkoutPlanEntity> plans = [];
                if (workoutState is WorkoutPlansLoaded) {
                  plans = workoutState.workoutPlans;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (plans.isNotEmpty && !_isCustomPlan)
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonFormField<WorkoutPlanEntity>(
                          initialValue: _selectedPlan,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            hintText: 'Select a workout plan',
                          ),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(16),
                          items: plans.map((plan) {
                            return DropdownMenuItem(
                              value: plan,
                              child: Text(
                                plan.planName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (plan) {
                            setState(() {
                              _selectedPlan = plan;
                              if (plan != null) {
                                _planNameController.text = plan.planName;
                              }
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _isCustomPlan = !_isCustomPlan),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isCustomPlan
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  size: 20,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Custom plan name',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isCustomPlan) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _planNameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter plan name',
                          prefixIcon: Icon(
                            Icons.fitness_center_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            //     Date Selector
            Text(
              'Schedule Date',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            //     Status Selector
            Text(
              'Status',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ScheduleStatus.values.map((s) {
                final isSelected = _selectedStatus == s;
                final color = _statusColor(s);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: s != ScheduleStatus.values.last ? 8 : 0,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        color: isSelected
                            ? color.withValues(alpha: 0.15)
                            : theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => setState(() => _selectedStatus = s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  _statusIcon(s),
                                  size: 18,
                                  color: isSelected
                                      ? color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  s.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? color
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            //     Note
            Text(
              'Note',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Add a note...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.note_alt_outlined, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 28),

            //     Save Button
            _GradientButton(
              text: _isEditing ? 'Update Schedule' : 'Save Schedule',
              onPressed: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _onSave() {
    // Determine plan name
    final planName = _isCustomPlan || _selectedPlan == null
        ? _planNameController.text.trim()
        : _selectedPlan!.planName;

    if (planName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a plan name')),
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final schedule = WorkoutScheduleEntity(
      scheduleId: widget.existingSchedule?.scheduleId ?? 0,
      userId: userId,
      planId: _isCustomPlan ? null : _selectedPlan?.planId,
      planName: planName,
      scheduleDate: _selectedDate,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      status: _selectedStatus,
      createdAt: widget.existingSchedule?.createdAt ?? DateTime.now(),
    );

    final bloc = context.read<ScheduleBloc>();
    if (_isEditing) {
      bloc.add(ScheduleUpdateRequested(schedule: schedule));
    } else {
      bloc.add(ScheduleAddRequested(schedule: schedule));
    }

    Navigator.of(context).pop();
  }

  Color _statusColor(ScheduleStatus s) {
    switch (s) {
      case ScheduleStatus.upcoming:
        return const Color(0xFF5B8DEF);
      case ScheduleStatus.inProgress:
        return const Color(0xFFFF9B52);
      case ScheduleStatus.done:
        return const Color(0xFF4CD964);
    }
  }

  IconData _statusIcon(ScheduleStatus s) {
    switch (s) {
      case ScheduleStatus.upcoming:
        return Icons.access_time_rounded;
      case ScheduleStatus.inProgress:
        return Icons.play_circle_outline_rounded;
      case ScheduleStatus.done:
        return Icons.check_circle_outline_rounded;
    }
  }
}

/// Edit/Save button
class _GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: const LinearGradient(
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF92A3FD).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(99),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
