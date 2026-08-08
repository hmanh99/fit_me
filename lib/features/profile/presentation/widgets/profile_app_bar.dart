import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
    required this.title,
    this.onBack,
    required this.centerTitle,
  });

  final String title;
  final VoidCallback? onBack;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: ColorConstants.white,
              onPressed: onBack,
            )
          : null,
      automaticallyImplyLeading: onBack != null,
      title: Text(
        title,
        style: const TextStyle(
          color: ColorConstants.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      toolbarHeight: 64,
      elevation: 0,
      backgroundColor: ColorConstants.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
         color: ColorConstants.appBarBackgroundColor,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(64);
}
