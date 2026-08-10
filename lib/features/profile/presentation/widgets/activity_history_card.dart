import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';

class ActivityHistoryCard extends StatelessWidget {
  final ActivityHistoryEntity history;

  const ActivityHistoryCard({super.key, required this.history});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    if (minutes < 1) return '< 1m';
    if (minutes < 60) return '$minutes m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final startTimeStr = DateFormat(
      'HH:mm',
    ).format(history.startedAt.toLocal());
    final endTimeStr = DateFormat(
      'HH:mm',
    ).format(history.completedAt.toLocal());

    final durationStr = _formatDuration(history.duration);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: ColorConstants.greyShade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            //icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorConstants.buttonColor
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: ColorConstants.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 16),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.planName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: ColorConstants.greyShade50,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$startTimeStr - $endTimeStr',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.greyShade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Duration & Status Chip
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF92A3FD).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    durationStr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92A3FD),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: ColorConstants.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'activity_complete_status'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
