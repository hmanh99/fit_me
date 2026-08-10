import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class MealLoadingSkeleton extends StatelessWidget {
  const MealLoadingSkeleton({super.key,this.isDetail = false});

  final bool isDetail;

  @override
  Widget build(BuildContext context) {
    return isDetail ? _buildDetailMeal() : _buildListMeal();
  }

  Widget _buildDetailMeal() {
    return ShimmerLoading(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSkeleton(
                width: double.infinity,
                height: 250,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  AppSkeleton.line(width: 80, height: 22),
                  SizedBox(width: 12),
                  AppSkeleton.line(width: 110, height: 22),
                ],
              ),
              const SizedBox(height: 16),
              // Title skeleton
              const AppSkeleton.line(width: 220, height: 28),
              const SizedBox(height: 8),
              const AppSkeleton.line(width: 150, height: 16),
              const SizedBox(height: 24),
              // Calories/nutrition card skeleton
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const AppSkeleton.circle(size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          AppSkeleton.line(width: 80, height: 12),
                          SizedBox(height: 6),
                          AppSkeleton.line(width: 120, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const AppSkeleton.line(width: 100, height: 20),
              const SizedBox(height: 16),
              ...List.generate(
                6,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        AppSkeleton.circle(size: 20),
                        SizedBox(width: 12),
                        AppSkeleton.line(width: 140, height: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListMeal() {
    {
      return ShimmerLoading(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: 6,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Image skeleton
                  const AppSkeleton(
                    width: 80,
                    height: 80,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  const SizedBox(width: 16),
                  // Text details skeleton
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppSkeleton.line(width: 70, height: 12),
                        const SizedBox(height: 8),
                        const AppSkeleton.line(width: 150, height: 16),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            AppSkeleton.line(width: 50, height: 12),
                            SizedBox(width: 12),
                            AppSkeleton.line(width: 60, height: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Arrow or detail button skeleton placeholder
                  const AppSkeleton.circle(size: 28),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
