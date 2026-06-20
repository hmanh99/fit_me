import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class ExerciseLoadingSkeleton extends StatelessWidget {
  final int count;
  final bool isDetailPage;

  const ExerciseLoadingSkeleton({
    super.key,
    this.count = 4,
    this.isDetailPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: isDetailPage
          ? _buildDetailSkeleton()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: count,
              itemBuilder: (context, index) => _buildListCardSkeleton(),
            ),
    );
  }

  Widget _buildDetailSkeleton() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white38,
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
              color: Colors.white38,
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
              color: Colors.white38,
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
              color: Colors.white38,
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
    return SingleChildScrollView();
  }
}
