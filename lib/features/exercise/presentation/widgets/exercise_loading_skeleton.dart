import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseLoadingSkeleton extends StatefulWidget {
  final int count;
  final bool isDetailPage;

  const ExerciseLoadingSkeleton({
    super.key,
    this.count = 4,
    this.isDetailPage = false,
  });

  @override
  State<ExerciseLoadingSkeleton> createState() =>
      _ExerciseLoadingSkeletonState();
}

class _ExerciseLoadingSkeletonState extends State<ExerciseLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.isDetailPage
              ? _buildDetailSkeleton()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: widget.count,
                  itemBuilder: (context, index) => _buildListCardSkeleton(),
                ),
        );
      },
    );
  }

  Widget _buildDetailSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(ExerciseTheme.horizontalPadding),
      child: Column(
        children: [
          _SkeletonBox(height: 160, radius: ExerciseTheme.cardRadius),
          const SizedBox(height: 16),
          _SkeletonBox(height: 120, radius: ExerciseTheme.cardRadius),
          const SizedBox(height: 16),
          _SkeletonBox(height: 200, radius: ExerciseTheme.cardRadius),
        ],
      ),
    );
  }

  Widget _buildListCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ExerciseTheme.horizontalPadding,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ExerciseTheme.cardRadius),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 52, height: 52, radius: 16),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SkeletonBox(width: 60, height: 14, radius: 4),
                    const SizedBox(width: 8),
                    _SkeletonBox(width: 80, height: 14, radius: 4),
                  ],
                ),
                const SizedBox(height: 10),
                _SkeletonBox(width: double.infinity, height: 18, radius: 4),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _SkeletonBox(width: 50, height: 12, radius: 4),
                    const SizedBox(width: 16),
                    _SkeletonBox(width: 70, height: 12, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({
    this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
