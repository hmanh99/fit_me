import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/widgets/exercise_theme.dart';

class ExerciseGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final bool centerTitle;

  const ExerciseGradientAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
              onPressed: onBack,
            )
          : null,
      automaticallyImplyLeading: onBack != null,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: 0.3,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: centerTitle,
      toolbarHeight: 64,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(gradient: ExerciseTheme.gradient),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }
}
