import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {

    final defaultBase =  ColorConstants.greyShade300 ;
    final defaultHighlight = ColorConstants.greyShade500;

    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBase,
      highlightColor: highlightColor ?? defaultHighlight,
      child: child,
    );
  }
}

class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  const AppSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null,
      shape = BoxShape.circle;

  const AppSkeleton.line({
    super.key,
    this.width,
    this.height = 13,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  }) : shape = BoxShape.rectangle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : (borderRadius ?? BorderRadius.circular(8)),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.greyShade100),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:
          child ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSkeleton.line(width: 120, height: 14),
              SizedBox(height: 8),
              AppSkeleton.line(width: double.infinity, height: 10),
              SizedBox(height: 8),
              AppSkeleton.line(width: 180, height: 10),
            ],
          ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          // Leading icon placeholder
          AppSkeleton.circle(size: 32),
          SizedBox(width: 16),
          // Middle text placeholder
          Expanded(child: AppSkeleton.line(width: 120, height: 14)),
          SizedBox(width: 16),
          // Trailing icon placeholder
          AppSkeleton.circle(size: 16),
        ],
      ),
    );
  }
}
