import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/features/profile/presentation/widgets/section_card.dart';
import 'package:fit_me/features/profile/presentation/widgets/activity_heatmap.dart';

class ActivityHeatmapCard extends StatelessWidget {
  final Map<DateTime, int> heatmapCounts;
  final int selectedDays;
  final ValueChanged<int>? onRangeChanged;
  final void Function(DateTime date, int count)? onDayTap;

  const ActivityHeatmapCard({
    super.key,
    required this.heatmapCounts,
    this.selectedDays = 365,
    this.onRangeChanged,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'heatmap_overview_title'.tr(),
      child: ActivityHeatmap(
        activityCounts: heatmapCounts,
        days: selectedDays,
        onDayTap: onDayTap,
      ),
    );
  }
}
