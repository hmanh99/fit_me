import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/core/router/route_paths.dart';

/// A safe fallback for a stale or malformed deep link.
class InvalidRouteScreen extends StatelessWidget {
  const InvalidRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Unavailable screen'),
        backgroundColor: ColorConstants.appBarBackgroundColor,
        foregroundColor: ColorConstants.appBarForegroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.link_off_rounded,
                size: 56,
                color: ColorConstants.textSecondaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'This link is invalid or no longer available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go(AppRoutePaths.appHome),
                child: const Text('Go to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
