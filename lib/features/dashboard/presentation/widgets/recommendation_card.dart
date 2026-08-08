import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class RecommendationCard extends StatefulWidget {
  final VoidCallback onTap;
  final Map<String, dynamic> exercise;

  const RecommendationCard({
    super.key,
    required this.onTap,
    required this.exercise,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  bool _isPressed = false;
  late final bool _hasImage = widget.exercise['url'] != null ? true : false;

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
          width: 250,
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          decoration: BoxDecoration(
            color: ColorConstants.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ColorConstants.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: ColorConstants.borderLightColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: ColorConstants.placeholderDarkColor,
                ),
                child: _hasImage
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Image.network(
                          fit: BoxFit.fill,
                          widget.exercise['url'].toString(),
                        ),
                      )
                    : Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstants.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstants.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.fitness_center_rounded,
                            color: ColorConstants.buttonTextColor,
                            size: 30,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise name
                      Text(
                        widget.exercise['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textPrimaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: ColorConstants.caloriesIconColor,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.exercise['calories'].toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      // Target muscle / equipment
                      Row(
                        children: [
                          const Icon(
                            Icons.fitness_center_outlined,
                            color: ColorConstants.iconColor,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (widget.exercise['muscle_group'] as List).first,
                            style: const TextStyle(fontSize: 13, color: ColorConstants.textPrimaryColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.fitness_center_outlined,
                            color: ColorConstants.iconColor,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${((widget.exercise['equipment'] as List).length).toString()} equipments",
                            style: const TextStyle(fontSize: 13, color: ColorConstants.textPrimaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
