import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_names.dart';

void showExitConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('confirm_exit_dialog_title'.tr()),
        content: Text('confirm_exit_dialog_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('confirm_exit_dialog_continue_button'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.goNamed(AppRouteNames.appWorkouts);
            },
            child: Text(
              'confirm_exit_dialog_quit_button'.tr(),
              style: TextStyle(color: ColorConstants.red),
            ),
          ),
        ],
      );
    },
  );
}
