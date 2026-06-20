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
      enableDrag: true,
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

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 1,
      builder: (context, scrollController) => Container(
        margin: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Theme(
          data: theme.copyWith(inputDecorationTheme: inputDecorationTheme),
          child: SingleChildScrollView(
            controller: scrollController,
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
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  _isEditing ? 'Edit Schedule' : 'Schedule Workout',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Workout Plan Selector Label
                _buildSectionLabel(theme, 'Workout Plan'),
                const SizedBox(height: 8),

                BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, workoutState) {
                    if (workoutState is WorkoutLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(minHeight: 2),
                      );
                    }

                    List<WorkoutPlanEntity> plans = [];
                    if (workoutState is WorkoutPlansLoaded) {
                      plans = workoutState.workoutPlans;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (plans.isNotEmpty && !_isCustomPlan)
                          DropdownButtonFormField<WorkoutPlanEntity>(
                            initialValue: _selectedPlan,
                            decoration: const InputDecoration(
                              hintText: 'Select a workout plan',
                              prefixIcon: Icon(
                                Icons.fitness_center_rounded,
                                size: 20,
                              ),
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
                        if (_isCustomPlan) ...[
                          TextField(
                            controller: _planNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter plan name',
                              prefixIcon: Icon(
                                Icons.edit_note_rounded,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(
                                () => _isCustomPlan = !_isCustomPlan,
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _isCustomPlan
                                      ? theme.colorScheme.primary.withValues(
                                          alpha: 0.08,
                                        )
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.03,
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _isCustomPlan
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.2,
                                          )
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isCustomPlan
                                          ? Icons.check_box_rounded
                                          : Icons
                                                .check_box_outline_blank_rounded,
                                      size: 18,
                                      color: _isCustomPlan
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Custom plan name',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: _isCustomPlan
                                                ? theme.colorScheme.primary
                                                : theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            fontWeight: _isCustomPlan
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Date Selector Label
                _buildSectionLabel(theme, 'Schedule Date'),
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
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat(
                            'EEEE, MMMM dd, yyyy',
                          ).format(_selectedDate),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
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

                // Status Selector Label
                _buildSectionLabel(theme, 'Status'),
                const SizedBox(height: 8),

                Row(
                  children: ScheduleStatus.values.map((s) {
                    final isSelected = _selectedStatus == s;
                    final color = _statusColor(s);
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: s != ScheduleStatus.values.last ? 10 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedStatus = s),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.08)
                                  : theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : theme.colorScheme.outlineVariant
                                          .withValues(alpha: 0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.12),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? color.withValues(alpha: 0.12)
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _statusIcon(s),
                                    size: 18,
                                    color: isSelected
                                        ? color
                                        : theme.colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.7),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: isSelected
                                        ? color
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Note Label
                _buildSectionLabel(theme, 'Note (Optional)'),
                const SizedBox(height: 8),

                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Add workout objectives, details or reminders...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 44),
                      child: Icon(Icons.note_alt_outlined, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                _GradientButton(
                  text: _isEditing ? 'Update Schedule' : 'Save Schedule',
                  onPressed: _onSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        fontSize: 14,
        letterSpacing: 0.3,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF92A3FD)),
          ),
          child: child!,
        );
      },
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
        SnackBar(
          content: const Text('Please select or enter a plan name'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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

/// Edit/Save button with click feedback animation
class _GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _GradientButton({required this.text, required this.onPressed});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
          lowerBound: 0.0,
          upperBound: 0.05,
        )..addListener(() {
          setState(() {});
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animController.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _animController.value;

    return Transform.scale(
      scale: _scale,
      child: Container(
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
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            child: Center(
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
