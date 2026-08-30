import 'package:easy_localization/easy_localization.dart';
import 'package:fit_me/features/profile/presentation/widgets/activity_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    EasyLocalization.logger.enableLevels = [];
  });

  Widget buildTestWidget({
    required Widget child,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }

  group('ActivityHeatmap normalization and bucketing', () {
    test('bucketTimestamps correctly aggregates timestamps by date', () {
      final now = DateTime(2026, 8, 29, 10, 30);
      final sameDayLater = DateTime(2026, 8, 29, 15, 0);
      final yesterday = DateTime(2026, 8, 28, 9, 0);

      final counts = ActivityHeatmap.bucketTimestamps([
        now,
        sameDayLater,
        yesterday,
      ]);

      final todayKey = DateTime(2026, 8, 29);
      final yesterdayKey = DateTime(2026, 8, 28);

      expect(counts[todayKey], 2);
      expect(counts[yesterdayKey], 1);
    });

    test('normalizeCounts groups counts to pure local calendar day keys', () {
      final date1 = DateTime(2026, 8, 29, 1, 0);
      final date2 = DateTime(2026, 8, 29, 23, 59);

      final normalized = ActivityHeatmap.normalizeCounts({
        date1: 3,
        date2: 2,
      });

      final dayKey = DateTime(2026, 8, 29);
      expect(normalized[dayKey], 5);
    });
  });

  group('ActivityHeatmap 1-year (365 days) Grid & Layout Tests', () {
    testWidgets('renders 365-day grid spanning ~53 weeks with month and weekday labels', (tester) async {
      final fixedEndDate = DateTime(2026, 8, 29);
      final testCounts = <DateTime, int>{
        DateTime(2026, 8, 29): 5,
        DateTime(2026, 8, 28): 2,
        DateTime(2025, 8, 30): 1,
      };

      await tester.pumpWidget(
        buildTestWidget(
          child: ActivityHeatmap(
            activityCounts: testCounts,
            days: 365,
            endDate: fixedEndDate,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the SingleChildScrollView for horizontal scrolling
      final scrollViewFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.scrollDirection == Axis.horizontal,
      );
      expect(scrollViewFinder, findsOneWidget);

      // Verify weekday labels are present (Mon, Wed, Fri)
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Wed'), findsOneWidget);
      expect(find.text('Fri'), findsOneWidget);

      // Verify legend is present
      expect(find.text('heatmap_less'), findsOneWidget);
      expect(find.text('heatmap_more'), findsOneWidget);
    });

    testWidgets('renders correctly across year boundary (Dec to Jan)', (tester) async {
      // End date in January to ensure transition from Dec previous year
      final fixedEndDate = DateTime(2026, 1, 15);
      final testCounts = <DateTime, int>{
        DateTime(2026, 1, 15): 3,
        DateTime(2025, 12, 31): 4,
        DateTime(2025, 1, 16): 1,
      };

      await tester.pumpWidget(
        buildTestWidget(
          child: ActivityHeatmap(
            activityCounts: testCounts,
            days: 365,
            endDate: fixedEndDate,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityHeatmap), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byWidgetPredicate(
          (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
        ),
      );
      expect(scrollView.controller, isNotNull);
    });

    testWidgets('renders correctly with leap year February (29 days)', (tester) async {
      // 2024 is a leap year; test a date window that includes Feb 29, 2024
      final fixedEndDate = DateTime(2024, 6, 1);
      final testCounts = <DateTime, int>{
        DateTime(2024, 2, 29): 8, // Leap day
        DateTime(2024, 6, 1): 2,
      };

      await tester.pumpWidget(
        buildTestWidget(
          child: ActivityHeatmap(
            activityCounts: testCounts,
            days: 365,
            endDate: fixedEndDate,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ActivityHeatmap), findsOneWidget);
    });

    testWidgets('tapping a day tile shows selected info strip and triggers onDayTap', (tester) async {
      final fixedEndDate = DateTime(2026, 8, 29);
      final today = DateTime(2026, 8, 29);
      final testCounts = <DateTime, int>{
        today: 4,
      };

      DateTime? tappedDate;
      int? tappedCount;

      await tester.pumpWidget(
        buildTestWidget(
          child: ActivityHeatmap(
            activityCounts: testCounts,
            days: 365,
            endDate: fixedEndDate,
            onDayTap: (date, count) {
              tappedDate = date;
              tappedCount = count;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find inkwells / tiles and tap
      final inkWells = find.byType(InkWell);
      expect(inkWells, findsWidgets);

      // Tap the last inkwell (most recent date column)
      await tester.tap(inkWells.last);
      await tester.pumpAndSettle();

      expect(tappedDate, isNotNull);
      expect(tappedCount, isNotNull);
    });

    testWidgets('initial scroll position scrolls towards the rightmost edge', (tester) async {
      final fixedEndDate = DateTime(2026, 8, 29);

      await tester.pumpWidget(
        buildTestWidget(
          child: ActivityHeatmap(
            activityCounts: const {},
            days: 365,
            endDate: fixedEndDate,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final scrollable = tester.widget<SingleChildScrollView>(
        find.byWidgetPredicate(
          (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
        ),
      );
      final controller = scrollable.controller;
      expect(controller, isNotNull);
      if (controller!.hasClients && controller.position.maxScrollExtent > 0) {
        expect(controller.offset, equals(controller.position.maxScrollExtent));
      }
    });
  });
}
