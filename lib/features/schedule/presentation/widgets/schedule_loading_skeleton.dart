import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/shared/widgets/skeletons.dart';

class ScheduleLoadingSkeleton extends StatelessWidget {
  const ScheduleLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppSkeleton.circle(size: 40),
                AppSkeleton.line(width: 100),
                AppSkeleton.circle(size: 40),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: ColorConstants.white24,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                  AppSkeleton.line(width: 22),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppSkeleton.line(height: 24, width: 100),
            const SizedBox(height: 16),
            scheduleCard(),
            const SizedBox(height: 16),
            scheduleCard(),
          ],
        ),
      ),
    );
  }
}

Widget scheduleCard(){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ColorConstants.white24,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppSkeleton.line(width: 20,),
            const SizedBox(width: 8,),
            AppSkeleton.line(width: 100,),
          ],
        ),
        const SizedBox(height: 12,),
        AppSkeleton.line(),
      ],
    ),
  );
}