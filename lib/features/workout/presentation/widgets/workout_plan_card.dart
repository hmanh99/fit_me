import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';

class WorkoutPlanCard extends StatefulWidget {
  final WorkoutPlanEntity plan;
  final VoidCallback? onTap;

  const WorkoutPlanCard({super.key, required this.plan, this.onTap});

  @override
  State<WorkoutPlanCard> createState() => _WorkoutPlanCardState();
}

class _WorkoutPlanCardState extends State<WorkoutPlanCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: ColorConstants.white.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorConstants.blue.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorConstants.blue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.fitness_center_rounded,
                        color: ColorConstants.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plan Name
                          Text(
                            widget.plan.planName,
                            style: const TextStyle(
                              color: ColorConstants.buttonTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (widget.plan.description != null &&
                              widget.plan.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            // Plan Description
                            Text(
                              widget.plan.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorConstants.buttonTextColor
                                    .withValues(alpha: 0.85),
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sleek arrow button container
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: ColorConstants.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: ColorConstants.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
