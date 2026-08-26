import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fit_me/core/router/route_names.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/profile_state.dart';
import 'package:fit_me/features/profile/presentation/widgets/menu_tile.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_error_state.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_header.dart';
import 'package:fit_me/features/profile/presentation/widgets/profile_skeletons.dart';
import 'package:fit_me/features/profile/presentation/widgets/section_card.dart';

import '../../../../core/constants/color_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.initialTab, super.key});

  final String? initialTab;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthServices _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthServices();
    context.read<ProfileBloc>().add(
      ProfileFetched(userId: _authService.user!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            const ProfileScreenSkeleton();
          }
          if (state is ProfileLogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorConstants.errorColor,
              ),
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final profile = state.profile;
          if (profile != null) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProfileBloc>().add(
                  ProfileFetched(userId: profile.userId),
                );
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeader(profile: profile),
                      const SizedBox(height: 16),
                      SectionCard(
                        title: 'profile_account_section'.tr(),
                        child: Column(
                          children: [
                            MenuTile(
                              icon: Icons.person_outline_rounded,
                              label: 'profile_personal_data_title'.tr(),
                              onTap: () {
                                context.goNamed(
                                  AppRouteNames.appProfileDetail,
                                  pathParameters: {'profileId': profile.userId},
                                );
                              },
                            ),
                            MenuTile(
                              icon: Icons.history,
                              label: 'profile_activity_history_title'.tr(),
                              onTap: () {
                                context.goNamed(
                                  AppRouteNames.appProfileActivityHistory,
                                );
                              },
                            ),
                            MenuTile(
                              icon: Icons.logout,
                              label: 'logout'.tr(),
                              isLogout: true,
                              onTap: () {
                                context.read<ProfileBloc>().add(
                                  const ProfileLogoutEvent(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SectionCard(
                        title: 'profile_other_section'.tr(),
                        child: Column(
                          children: [
                            MenuTile(
                              icon: Icons.settings_outlined,
                              label: 'settings'.tr(),
                              onTap: () => context.goNamed(
                                AppRouteNames.appProfileSettings,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            ProfileErrorState(
              state: state,
              onTap: () => context.read<ProfileBloc>().add(
                ProfileFetched(userId: _authService.user!.id),
              ),
            );
          }
          return const ProfileScreenSkeleton();
        },
      ),
    );
  }
}
