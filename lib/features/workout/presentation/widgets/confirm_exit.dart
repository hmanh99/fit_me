import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';

void showExitConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Quit Workout?'),
        content: const Text(
          'Are you sure you want to exit? Your progress for this session will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continue Workout'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.goNamed(AppRouteNames.appWorkouts);
            },
            child: const Text(
              'Quit',
              style: TextStyle(color: ColorConstants.red),
            ),
          ),
        ],
      );
    },
  );
}