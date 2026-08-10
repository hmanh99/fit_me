import 'package:flutter/material.dart';
import 'package:fit_me/shared/widgets/skeletons.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16,
          8,
          16,
          MediaQuery.of(context).padding.bottom,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SkeletonHeader(),
            const SizedBox(height: 24),

            const AppSkeleton.line(width: 130, height: 16),
            const SizedBox(height: 16),

            _SkeletonQuickActionsGrid(),
            const SizedBox(height: 24),

            const AppSkeleton.line(width: 130, height: 16),
            const SizedBox(height: 16),

            _SkeletonChallengeCard(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                AppSkeleton.line(width: 150, height: 16),
                AppSkeleton.line(width: 60, height: 13),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return _SkeletonRecommendationCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppSkeleton.line(width: 160, height: 22),
            SizedBox(height: 8),
            AppSkeleton.line(width: 210, height: 14),
          ],
        ),
        AppSkeleton(
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}

class _SkeletonChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      width: double.infinity,
      height: 140,
      borderRadius: BorderRadius.circular(24),
    );
  }
}

class _SkeletonQuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: List.generate(
        4,
        (_) => AppSkeleton(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class _SkeletonRecommendationCard extends StatelessWidget {
  const _SkeletonRecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: AppSkeleton(
        width: 250,
        height: 250,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
