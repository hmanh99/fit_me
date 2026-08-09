import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/constants/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_event.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_state.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/bmi_card.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_error_state.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_header.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_skeletons.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/stat_card.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String profileId;

  const ProfileDetailScreen({super.key, required this.profileId});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileFetched(userId: widget.profileId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: ProfileAppBar(
        title: "profile_personal_data_title".tr(),
        centerTitle: true,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const ProfileDetailScreenSkeleton();
            }

            if (state is ProfileLoaded) {
              return _ProfileBody(profile: state.profile);
            }

            if (state is ProfileUpdating) {
              return _ProfileBody(profile: state.profile);
            }

            if (state is ProfileError) {
              ProfileErrorState(
                state: state,
                onTap: () => context.read<ProfileBloc>().add(
                  ProfileFetched(userId: widget.profileId),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.profile});

  final ProfileEntity profile;

  String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'bmi_underweight'.tr();
    if (bmi < 25) return 'bmi_normal'.tr();
    if (bmi < 30) return 'bmi_overweight'.tr();
    return 'bmi_obese'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final bmi =
        profile.weight / ((profile.height / 100) * (profile.height / 100));
    final bmiCategory = _bmiCategory(bmi);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(profile: profile),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.height_rounded,
                  label: "height".tr(),
                  value: profile.height.toStringAsFixed(0),
                  unit: "cm",
                  color: ColorConstants.iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  icon: Icons.fitness_center_rounded,
                  label: "weight".tr(),
                  value: profile.weight.toStringAsFixed(0),
                  unit: "kg",
                  color: ColorConstants.iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BmiCard(bmi: bmi, category: bmiCategory),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorConstants.buttonColor,
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.buttonColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                context.goNamed(
                  AppRouteNames.appProfileEdit,
                  pathParameters: {'profileId': profile.userId},
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_rounded,
                    color: ColorConstants.buttonTextColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "profile_edit_profile_button".tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.buttonTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
