import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/shared/widgets/skeletons.dart';

class WorkoutLoadingSkeleton extends StatelessWidget {
  final bool isDetailPage;

  const WorkoutLoadingSkeleton({super.key, this.isDetailPage = false});

  @override
  Widget build(BuildContext context) {
    return isDetailPage ? _buildDetailSkeleton() : _buildPlanSkeleton();
  }

  Widget _buildPlanSkeleton() {
    return ShimmerLoading(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(height: 24,width: 200,),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(height: 24,width: 200,),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(height: 24,width: 200,),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(height: 24,width: 200,),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(height: 24,width: 200,),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSkeleton() {
    return ShimmerLoading(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppSkeleton.line(height: 24, width: 150),
                      AppSkeleton.line(height: 24, width: 50),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppSkeleton.line(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      AppSkeleton.line(width: 100),
                      const SizedBox(width: 16),
                      AppSkeleton.line(width: 100),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppSkeleton.line(width: 100),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AppSkeleton.circle(size: 50),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      AppSkeleton.line(width: 200,),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          AppSkeleton.line(width: 70),
                          const SizedBox(width: 8),
                          AppSkeleton.line(width: 70),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
