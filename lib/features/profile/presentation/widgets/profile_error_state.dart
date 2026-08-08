import 'package:flutter/material.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_state.dart';

class ProfileErrorState extends StatelessWidget {
  const ProfileErrorState({super.key, required this.state, this.onTap});

  final ProfileError state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: ColorConstants.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: ColorConstants.greyShade100),
        ),
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstants.errorColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: ColorConstants.errorColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Failed to load profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.message,
                style: TextStyle(
                  fontSize: 13,
                  color: ColorConstants.greyShade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.redAccent,
                  foregroundColor: ColorConstants.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onTap,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
