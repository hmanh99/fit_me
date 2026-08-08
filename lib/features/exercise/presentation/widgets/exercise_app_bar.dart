import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class ExerciseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const ExerciseAppBar({super.key, required this.title, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: ColorConstants.appBarForegroundColor,
              onPressed: onBack,
            )
          : null,
      automaticallyImplyLeading: onBack != null,
      title: Text(
        title,
        style: const TextStyle(
          color: ColorConstants.appBarForegroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      toolbarHeight: 64,
      elevation: 0,
      backgroundColor: ColorConstants.appBarBackgroundColor,
    );
  }
}
