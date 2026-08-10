import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
class MealItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  const MealItem({
    super.key,
    required this.text,
    this.icon = Icons.check_circle_outline_rounded,
    this.iconColor = ColorConstants.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConstants.borderLightColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: ColorConstants.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
