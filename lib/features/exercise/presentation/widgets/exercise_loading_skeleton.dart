import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class ExerciseLoadingSkeleton extends StatelessWidget {
  final int count;
  final bool isDetailPage;

  const ExerciseLoadingSkeleton({
    super.key,
    this.count = 15,
    this.isDetailPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: isDetailPage
          ? _buildDetailSkeleton()
          : GridView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                20,
                16,
                MediaQuery.of(context).padding.bottom,
              ),
              itemCount: count,
              itemBuilder: (context, index) => _buildListCardSkeleton(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
    );
  }

  Widget _buildDetailSkeleton() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.line(height: 24, width: 150),
                SizedBox(height: 8),
                AppSkeleton.line(height: 13, width: 150),
                SizedBox(height: 8),
                Row(
                  children: [
                    AppSkeleton.line(width: 100),
                    const SizedBox(width: 12),
                    AppSkeleton.line(width: 100),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.line(height: 16, width: 150),
                SizedBox(height: 8),
                Row(
                  children: [
                    AppSkeleton.line(height: 13, width: 100),
                    const SizedBox(width: 12),
                    AppSkeleton.line(height: 13, width: 100),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.line(height: 16, width: 150),
                SizedBox(height: 8),
                Row(
                  children: [
                    AppSkeleton.line(height: 13, width: 100),
                    const SizedBox(width: 12),
                    AppSkeleton.line(height: 13, width: 100),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton.line(height: 16, width: 150),
                SizedBox(height: 8),
                AppSkeleton.line(height: 13),
                SizedBox(height: 8),
                AppSkeleton.line(height: 13),
                SizedBox(height: 8),
                AppSkeleton.line(height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCardSkeleton() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 120,
            decoration: BoxDecoration(
              color: ColorConstants.white24,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    );
  }
}
