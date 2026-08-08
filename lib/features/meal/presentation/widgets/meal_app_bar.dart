import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class MealAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MealAppBar({super.key, required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: ColorConstants.appBarForegroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: ColorConstants.appBarForegroundColor,
              onPressed: onBack,
            )
          : null,
      centerTitle: true,
      toolbarHeight: 64,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: ColorConstants.appBarBackgroundColor
        ),
      ),
    );
  }
}
