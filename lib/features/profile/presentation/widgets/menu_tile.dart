import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/profile/presentation/widgets/menu_row.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return MenuRow(
      icon: icon,
      label: label,
      isDestructive: isLogout,
      trailing: Icon(
        Icons.chevron_right_rounded, 
        color: isLogout ? ColorConstants.red.withValues(alpha: 0.5) : ColorConstants.greyShade400,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

