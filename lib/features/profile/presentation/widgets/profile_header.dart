import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.greyShade100, width: 1),
      ),
      child: Row(
        children: [
        Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorConstants.primaryColor,
            width: 2.0,
          ),
        ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: ColorConstants.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: profile.avatar != null && profile.avatar!.isNotEmpty
                    ? Image.network(
                        profile.avatar!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: ColorConstants.greyShade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: ColorConstants.white,
                          ),
                        ),
                      )
                    : Container(
                        color: ColorConstants.greyShade300,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: ColorConstants.white,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  profile.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: ColorConstants.black,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor.withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorConstants.primaryColor.withValues(
                        alpha: 0.15,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.fingerprint_rounded,
                        size: 13,
                        color: ColorConstants.primaryColor.withValues(
                          alpha: 0.8,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'ID: ${profile.userId.length > 8 ? profile.userId.substring(0, 8) : profile.userId}...',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ColorConstants.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
