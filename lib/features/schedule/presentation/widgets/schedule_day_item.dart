import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/schedule_status.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';

/// A card that displays a single schedule entry for the selected day.
class ScheduleDayItem extends StatelessWidget {
  final WorkoutScheduleEntity schedule;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ScheduleDayItem({
    super.key,
    required this.schedule,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _statusInfo(schedule.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusInfo.color.withValues(alpha: 0.3),
                  statusInfo.color.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Row(
              children: [
                // Status icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusInfo.color.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    statusInfo.icon,
                    color: statusInfo.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.planName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusInfo.color.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              schedule.status.label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusInfo.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (schedule.note != null &&
                              schedule.note!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                schedule.note!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(schedule.scheduleDate),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: Colors.red.shade400),
                          const SizedBox(width: 8),
                          Text('Delete',
                              style: TextStyle(color: Colors.red.shade400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
          color: const Color(0xFF5B8DEF),
        );
      case ScheduleStatus.inProgress:
        return _StatusInfo(
          icon: Icons.play_circle_outline_rounded,
          color: const Color(0xFFFF9B52),
        );
      case ScheduleStatus.done:
        return _StatusInfo(
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF4CD964),
        );
    }
  }
}

class _StatusInfo {
  final IconData icon;
  final Color color;

  const _StatusInfo({required this.icon, required this.color});
}
