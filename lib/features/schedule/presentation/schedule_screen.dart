import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/widgets/add_schedule_bottom_sheet.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/widgets/calendar_header.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/widgets/schedule_day_item.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/widgets/workout_marker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void _loadSchedules() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    context.read<ScheduleBloc>().add(
      ScheduleLoadRequested(
        userId: userId,
        year: _focusedDay.year,
        month: _focusedDay.month,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      listenWhen: (prev, curr) => prev.operationStatus != curr.operationStatus,
      listener: (context, state) {
        if (state.operationStatus == ScheduleOperationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Schedule updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<ScheduleBloc>().add(
            const ScheduleOperationStatusReset(),
          );
        } else if (state.operationStatus == ScheduleOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Operation failed'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          context.read<ScheduleBloc>().add(
            const ScheduleOperationStatusReset(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Schedule',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                Material(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() {
                        _focusedDay = DateTime.now();
                        _selectedDay = DateTime.now();
                      });
                      context.read<ScheduleBloc>().add(
                        ScheduleDateSelected(selectedDate: DateTime.now()),
                      );
                      _loadSchedules();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.today_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            toolbarHeight: 60,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Calendar
                Expanded(child: _buildBody(theme, state)),
              ],
            ),
          ),
          floatingActionButton: _buildFloatingActionButton(theme),
        );
      },
    );
  }

  Widget _buildBody(ThemeData theme, ScheduleState state) {
    if (state.status == ScheduleStateStatus.loading &&
        state.allSchedules.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ScheduleStateStatus.error &&
        state.allSchedules.isEmpty) {
      return _buildErrorState(theme, state);
    }

    return CustomScrollView(
      slivers: [     // // Calendar Header
        SliverToBoxAdapter(
          child: CalendarHeader(
            focusedDate: _focusedDay,
            onLeftArrowTap: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
              });
              _loadSchedules();
            },
            onRightArrowTap: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              });
              _loadSchedules();
            },
          ),
        ),

        // Calendar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TableCalendar<WorkoutScheduleEntity>(
              firstDay: DateTime(2000, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              /// Using custom header
              headerVisible: false,
              daysOfWeekHeight: 40,
              rowHeight: 56,
              // Events
              eventLoader: (day) {
                final key = DateTime(day.year, day.month, day.day);
                return state.markedDates[key] ?? [];
              },

              // Callbacks
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                context.read<ScheduleBloc>().add(
                  ScheduleDateSelected(selectedDate: selectedDay),
                );
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
                _loadSchedules();
              },

              //  Styling
              calendarStyle: CalendarStyle(
                // Today
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),

                // Selected
                selectedDecoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF92A3FD).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),

                // Default
                defaultTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                weekendTextStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                outsideTextStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),

                // Markers
                markersMaxCount: 3,
                markerSize: 6,
                markersAlignment: Alignment.bottomCenter,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1),
              ),

              // Days-of-week style
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                weekendStyle: theme.textTheme.bodySmall!.copyWith(
                  color:  Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),

              // Custom marker builder
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;
                  return Positioned(
                    bottom: 4,
                    child: WorkoutMarker(count: events.length),
                  );
                },
              ),
            ),
          ),
        ),

        // Divider
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('EEEE, MMMM dd').format(_selectedDay),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                if (state.selectedDateSchedules.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${state.selectedDateSchedules.length} workout${state.selectedDateSchedules.length > 1 ? 's' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        //     Schedule list
        if (state.selectedDateSchedules.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyDayState(theme),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final schedule = state.selectedDateSchedules[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(schedule.scheduleId),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 80)),
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
                child: ScheduleDayItem(
                  schedule: schedule,
                  onEdit: () => AddScheduleBottomSheet.show(
                    context,
                    existingSchedule: schedule,
                  ),
                  onDelete: () => _confirmDelete(context, schedule),
                ),
              );
            }, childCount: state.selectedDateSchedules.length),
          ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  Widget _buildEmptyDayState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.event_available_rounded,
            size: 36,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'No workouts scheduled',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap the + button to add a workout',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme, ScheduleState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: theme.colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load schedules',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loadSchedules,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF92A3FD).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => AddScheduleBottomSheet.show(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WorkoutScheduleEntity schedule) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Schedule'),
          content: Text(
            'Are you sure you want to delete "${schedule.planName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ScheduleBloc>().add(
                  ScheduleDeleteRequested(scheduleId: schedule.scheduleId),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
