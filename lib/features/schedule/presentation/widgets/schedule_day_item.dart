import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/schedule_status.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';

/// A card that displays a single schedule entry for the selected day.
class ScheduleDayItem extends StatelessWidget {
  final WorkoutScheduleEntity schedule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleDayItem({
    super.key,
    required this.schedule,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _statusInfo(schedule.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: 0.3,
                ),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Status colored left accent bar
                    Container(width: 5, color: statusInfo.color),
                    const SizedBox(width: 14),

                    // Main Card Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusInfo.color.withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: statusInfo.color.withValues(
                                        alpha: 0.18,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    schedule.status.label.toUpperCase(),
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                          color: statusInfo.color,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 9,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Date
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 11,
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat(
                                    'MMMM dd, yyyy',
                                  ).format(schedule.scheduleDate),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.7),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Plan Name
                            Text(
                              schedule.planName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Optional Note Box
                            if (schedule.note != null &&
                                schedule.note!.trim().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.sticky_note_2_outlined,
                                        size: 13,
                                        color: theme
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        schedule.note!,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withValues(alpha: 0.8),
                                              fontSize: 12,
                                              height: 1.4,
                                            ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Status Badge Icon + Action Menu
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Action buttons menu
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                              size: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                            shadowColor: ColorConstants.black.withValues(alpha: 0.15),
                            onSelected: (value) {
                              if (value == 'edit') onEdit?.call();
                              if (value == 'delete') onDelete?.call();
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 18),
                                    SizedBox(width: 10),
                                    Text('edit'.tr()),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: ColorConstants.deleteActionColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'delete'.tr(),
                                      style: TextStyle(color: ColorConstants.deleteActionColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Round Status Indicator Icon
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                              bottom: 14,
                            ),
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: statusInfo.color.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: statusInfo.color.withValues(
                                    alpha: 0.18,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                statusInfo.icon,
                                color: statusInfo.color,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
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
  }

  _StatusInfo _statusInfo(ScheduleStatus status) {
    switch (status) {
      case ScheduleStatus.upcoming:
        return _StatusInfo(
          icon: Icons.access_time_rounded,
          color: ColorConstants.scheduleUpcomingColor,
        );
      case ScheduleStatus.inProgress:
        return _StatusInfo(
          icon: Icons.play_circle_outline_rounded,
          color: ColorConstants.scheduleInProgressColor,
        );
      case ScheduleStatus.done:
        return _StatusInfo(
          icon: Icons.check_circle_outline_rounded,
          color: ColorConstants.scheduleDoneColor,
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;

  const _StatusInfo({required this.icon, required this.color});
}
