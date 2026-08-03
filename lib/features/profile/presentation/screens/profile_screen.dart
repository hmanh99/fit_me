import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_event.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/profile_state.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/menu_row.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/menu_tile.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_header.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/profile_skeletons.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/widgets/section_card.dart';

const Color _kAccentPurple = Color(0xFFC58BF2);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.initialTab, super.key});

  final String? initialTab;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthServices _authService;
  bool _popUpNotifications = true;

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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            const ProfileScreenSkeleton();
          }
          if (state is ProfileLogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${state.message}'),
                backgroundColor: Colors.red,
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
                      const SizedBox(height: 24),
                      SectionCard(
                        title: 'Account',
                        child: Column(
                          children: [
                            MenuTile(
                              icon: Icons.person_outline_rounded,
                              label: 'Personal Data',
                              onTap: () {
                                context.goNamed(
                                  AppRouteNames.appProfileDetail,
                                  pathParameters: {'profileId': profile.userId},
                                );
                              },
                            ),
                            _divider(),
                            MenuTile(
                              icon: Icons.history,
                              label: 'Activity History',
                              onTap: () {
                                context.goNamed(
                                  AppRouteNames.appProfileActivityHistory,
                                );
                              },
                            ),
                            _divider(),
                            MenuTile(
                              icon: Icons.logout,
                              label: 'Log out',
                              isDestructive: true,
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
                        title: 'Notification',
                        child: MenuRow(
                          icon: Icons.notifications_none_rounded,
                          label: 'Pop-up Notification',
                          trailing: Switch(
                            value: _popUpNotifications,
                            onChanged: (v) =>
                                setState(() => _popUpNotifications = v),
                            activeThumbColor: Colors.white,
                            activeTrackColor: _kAccentPurple,
                            inactiveThumbColor: Colors.grey.shade400,
                            inactiveTrackColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SectionCard(
                        title: 'Other',
                        child: Column(
                          children: [
                            MenuTile(
                              icon: Icons.mail_outline_rounded,
                              label: 'Contact Us',
                              onTap: () => _toast(context, 'Liên hệ'),
                            ),
                            _divider(),
                            MenuTile(
                              icon: Icons.shield_outlined,
                              label: 'Privacy Policy',
                              onTap: () => _toast(context, 'Privacy Policy'),
                            ),
                            _divider(),
                            MenuTile(
                              icon: Icons.settings_outlined,
                              label: 'Settings',
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
            return Center(
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.grey.shade100),
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
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          size: 40,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Failed to load profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () => context.read<ProfileBloc>().add(
                          ProfileFetched(userId: _authService.user!.id),
                        ),
                        child: const Text(
                          'Retry',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const ProfileScreenSkeleton();
        },
      ),
    );
  }

  void _toast(BuildContext context, String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label — sắp có')));
  }
}

Widget _divider() {
  return Divider(height: 1, thickness: 1, color: Colors.grey.shade100);
}
