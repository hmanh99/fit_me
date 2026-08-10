import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final themeColor = isDestructive ? ColorConstants.redAccent : ColorConstants.blue;

    return Material(
      color: ColorConstants.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: themeColor.withValues(alpha: 0.08),
        highlightColor: themeColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: themeColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDestructive
                        ? ColorConstants.redAccent
                        : ColorConstants.black.withValues(alpha: 0.85),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: 0,
                child: trailing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
