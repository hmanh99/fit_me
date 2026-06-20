import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/menu_row.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return MenuRow(
      icon: icon,
      label: label,
      isDestructive: isDestructive,
      trailing: Icon(
        Icons.chevron_right_rounded, 
        color: isDestructive ? Colors.redAccent.withValues(alpha: 0.5) : Colors.grey.shade400,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}

