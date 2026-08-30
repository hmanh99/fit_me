import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class ActivityHeatmap extends StatefulWidget {
  final Map<DateTime, int>? activityCounts;
  final List<DateTime>? timestamps;
  final int days;
  final DateTime? endDate; // Today
  final void Function(DateTime date, int count)? onDayTap;
  final List<Color>? colorScale;
  final Color? inactiveColor;
  final bool showLegend;
  final bool showWeekdayLabels;
  final bool showMonthLabels;
  final double tileSize;
  final double tileSpacing;
  final double borderRadius;
  final int firstDayOfWeek;

  const ActivityHeatmap({
    super.key,
    this.activityCounts,
    this.timestamps,
    this.days = 365,
    this.endDate,
    this.onDayTap,
    this.colorScale,
    this.inactiveColor,
    this.showLegend = true,
    this.showWeekdayLabels = true,
    this.showMonthLabels = true,
    this.tileSize = 16.0,
    this.tileSpacing = 4.0,
    this.borderRadius = 4.0,
    this.firstDayOfWeek = DateTime.monday,
  }) : assert(
         activityCounts != null || timestamps != null,
         'Either activityCounts or timestamps must be provided',
       );


  // Bucket timestamps with activity count
  static Map<DateTime, int> bucketTimestamps(List<DateTime> rawTimestamps) {
    final Map<DateTime, int> counts = {};
    for (final raw in rawTimestamps) {
      final local = raw.toLocal();
      final dayKey = DateTime(local.year, local.month, local.day);
      counts[dayKey] = (counts[dayKey] ?? 0) + 1;
    }
    return counts;
  }

  // Normalize any date map to pure local calendar day keys.
  static Map<DateTime, int> normalizeCounts(Map<DateTime, int> rawCounts) {
    final Map<DateTime, int> normalized = {};
    rawCounts.forEach((date, count) {
      final local = date.toLocal();
      final dayKey = DateTime(local.year, local.month, local.day);
      normalized[dayKey] = (normalized[dayKey] ?? 0) + count;
    });
    return normalized;
  }

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  DateTime? _selectedDate;
  int? _selectedCount;
  late final ScrollController _scrollController;

  static const Color _defaultInactiveColor = ColorConstants.greyShade100;
  static const double _monthHeaderHeight = 24.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void didUpdateWidget(covariant ActivityHeatmap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.days != widget.days || oldWidget.endDate != widget.endDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Map<DateTime, int> get _processedCounts {
    if (widget.activityCounts != null) {
      return ActivityHeatmap.normalizeCounts(widget.activityCounts!);
    }
    if (widget.timestamps != null) {
      return ActivityHeatmap.bucketTimestamps(widget.timestamps!);
    }
    return {};
  }

  List<Color> get _colorScale =>
      widget.colorScale ?? ColorConstants.heatMapColor;

  Color get _inactiveColor => widget.inactiveColor ?? _defaultInactiveColor;

  int _getIntensityLevel(int count, int maxCount) {
    if (count <= 0) return 0;
    if (maxCount <= 1) return 1;
    final step = (maxCount / _colorScale.length).ceil();
    final level = ((count / (step == 0 ? 1 : step))).ceil();
    return math.min(level, _colorScale.length);
  }

  Color _getColorForCount(int count, int maxCount) {
    if (count <= 0) return _inactiveColor;
    final level = _getIntensityLevel(count, maxCount);
    final index = math.max(0, math.min(level - 1, _colorScale.length - 1));
    return _colorScale[index];
  }

  @override
  Widget build(BuildContext context) {
    final counts = _processedCounts;
    final now = widget.endDate?.toLocal() ?? DateTime.now();
    final endDay = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(now.year, now.month, now.day - (widget.days - 1));

    final int daysOffsetToFirstDay =
        (startDay.weekday - widget.firstDayOfWeek + 7) % 7;
    final gridStartDate = DateTime(
      startDay.year,
      startDay.month,
      startDay.day - daysOffsetToFirstDay,
    );

    final int daysOffsetToEndOfWeek =
        (widget.firstDayOfWeek + 6 - endDay.weekday + 7) % 7;
    final totalGridDays =
        daysOffsetToFirstDay + widget.days + daysOffsetToEndOfWeek;
    final numberOfWeeks = totalGridDays ~/ 7;

    int maxCount = 0;
    int totalActivities = 0;
    counts.forEach((date, count) {
      if (!date.isBefore(startDay) && !date.isAfter(endDay)) {
        if (count > maxCount) maxCount = count;
        totalActivities += count;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header summary
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ColorConstants.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${'profile_activity_history_title'.tr()} ($totalActivities)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.textPrimaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstants.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${widget.days} ${'days'.tr()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Heatmap
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekday
            if (widget.showWeekdayLabels) ...[
              _buildWeekdayLabels(),
              const SizedBox(width: 6),
            ],

            // Horizontally scrollable heatmap grid
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.showMonthLabels)
                      _buildMonthLabels(
                        gridStartDate: gridStartDate,
                        numberOfWeeks: numberOfWeeks,
                        startDay: startDay,
                        endDay: endDay,
                      ),
                    _buildHeatmapGrid(
                      gridStartDate: gridStartDate,
                      numberOfWeeks: numberOfWeeks,
                      startDay: startDay,
                      endDay: endDay,
                      counts: counts,
                      maxCount: maxCount,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Selected date
        if (_selectedDate != null) ...[
          const SizedBox(height: 10),
          _buildSelectedInfoStrip(),
        ],

        // Legend at bottom
        if (widget.showLegend) ...[
          const SizedBox(height: 12),
          _buildLegend(maxCount),
        ],
      ],
    );
  }

  Widget _buildWeekdayLabels() {
    final weekdays = ['Mon', '', 'Wed', '', 'Fri', '', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.showMonthLabels) const SizedBox(height: _monthHeaderHeight),
        for (int i = 0; i < 7; i++)
          SizedBox(
            height: widget.tileSize + widget.tileSpacing,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                weekdays[i],
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.greyShade600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthLabels({
    required DateTime gridStartDate,
    required int numberOfWeeks,
    required DateTime startDay,
    required DateTime endDay,
  }) {
    final double colWidth = widget.tileSize + widget.tileSpacing;
    final List<Widget> labelWidgets = [];

    final Map<int, List<int>> monthToCols = {};
    final Map<int, int> monthDayCount = {};

    for (int col = 0; col < numberOfWeeks; col++) {
      for (int row = 0; row < 7; row++) {
        final date = DateTime(
          gridStartDate.year,
          gridStartDate.month,
          gridStartDate.day + (col * 7) + row,
        );
        if (date.isBefore(startDay) || date.isAfter(endDay)) continue;

        final key = date.year * 100 + date.month;
        final list = monthToCols.putIfAbsent(key, () => []);
        if (list.isEmpty || list.last != col) {
          list.add(col);
        }
        monthDayCount[key] = (monthDayCount[key] ?? 0) + 1;
      }
    }

    // Sort month keys chronologically
    final sortedKeys = monthToCols.keys.toList()..sort();

    for (int i = 0; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      final cols = monthToCols[key]!;
      final dayCount = monthDayCount[key] ?? 0;

      if (cols.length == 1 && dayCount < 4 && sortedKeys.length > 1) {
        if (i == 0) continue; // Skip tiny leading sliver
      }

      final minCol = cols.first;
      final maxCol = cols.last;
      final spanWidth = (maxCol - minCol + 1) * colWidth;

      final year = key ~/ 100;
      final month = key % 100;
      final monthDate = DateTime(year, month, 1);
      final monthName = DateFormat('MMM').format(monthDate);

      labelWidgets.add(
        Positioned(
          left: minCol * colWidth,
          width: spanWidth,
          top: 0,
          child: Center(
            child: Text(
              monthName,
              maxLines: 1,
              overflow: TextOverflow.visible,
              softWrap: false,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: ColorConstants.greyShade700,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: _monthHeaderHeight,
      width: numberOfWeeks * colWidth,
      child: Stack(clipBehavior: Clip.none, children: labelWidgets),
    );
  }

  Widget _buildHeatmapGrid({
    required DateTime gridStartDate,
    required int numberOfWeeks,
    required DateTime startDay,
    required DateTime endDay,
    required Map<DateTime, int> counts,
    required int maxCount,
  }) {
    return Row(
      children: List.generate(numberOfWeeks, (colIndex) {
        return Padding(
          padding: EdgeInsets.only(right: widget.tileSpacing),
          child: Column(
            children: List.generate(7, (rowIndex) {
              final cellDate = DateTime(
                gridStartDate.year,
                gridStartDate.month,
                gridStartDate.day + (colIndex * 7) + rowIndex,
              );

              final isOutOfRange =
                  cellDate.isBefore(startDay) || cellDate.isAfter(endDay);

              if (isOutOfRange) {
                return SizedBox(
                  width: widget.tileSize,
                  height: widget.tileSize + widget.tileSpacing,
                );
              }

              final count = counts[cellDate] ?? 0;
              final tileColor = _getColorForCount(count, maxCount);
              final isSelected = _selectedDate == cellDate;

              final tooltipMessage = count == 0
                  ? '${DateFormat('EEE, MMM d, yyyy').format(cellDate)}: ${'heatmap_no_activity'.tr()}'
                  : '${DateFormat('EEE, MMM d, yyyy').format(cellDate)}: $count ${'heatmap_activities'.tr()}';

              return Padding(
                padding: EdgeInsets.only(bottom: widget.tileSpacing),
                child: Tooltip(
                  message: tooltipMessage,
                  preferBelow: false,
                  decoration: BoxDecoration(
                    color: ColorConstants.greyShade900,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    color: ColorConstants.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDate = cellDate;
                        _selectedCount = count;
                      });
                      widget.onDayTap?.call(cellDate, count);
                    },
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: widget.tileSize,
                      height: widget.tileSize,
                      decoration: BoxDecoration(
                        color: tileColor,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                        border: isSelected
                            ? Border.all(color: ColorConstants.black, width: 1)
                            : Border.all(
                                color: count > 0
                                    ? ColorConstants.primaryColor.withValues(
                                        alpha: 0.15,
                                      )
                                    : ColorConstants.greyShade300.withValues(
                                        alpha: 0.5,
                                      ),
                                width: 0.5,
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedInfoStrip() {
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!);
    final count = _selectedCount ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorConstants.greyShade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.greyShade200, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: ColorConstants.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: count > 0
                  ? ColorConstants.primaryColor
                  : ColorConstants.greyShade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count == 0
                  ? 'heatmap_no_activity'.tr()
                  : '$count ${'heatmap_activities'.tr()}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: ColorConstants.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(int maxCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'heatmap_less'.tr(),
          style: const TextStyle(
            fontSize: 10,
            color: ColorConstants.greyShade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        // Inactive tile
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: _inactiveColor,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorConstants.greyShade300, width: 0.5),
          ),
        ),
        const SizedBox(width: 3),
        for (final color in _colorScale) ...[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: ColorConstants.primaryColor.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 3),
        ],
        const SizedBox(width: 3),
        Text(
          'heatmap_more'.tr(),
          style: const TextStyle(
            fontSize: 10,
            color: ColorConstants.greyShade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
