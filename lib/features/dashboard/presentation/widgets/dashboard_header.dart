import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/services/auth_services.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onNotificationPressed;

  const DashboardHeader({super.key, this.onNotificationPressed});

  @override
  Widget build(BuildContext context) {
    final user = AuthServices();
    final username =
        user.user?.userMetadata?['username'] ?? 'default_username'.tr();
    return SafeArea(
      bottom: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'greeting'.tr(namedArgs: {'username': username}),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'tagline'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  color: ColorConstants.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}