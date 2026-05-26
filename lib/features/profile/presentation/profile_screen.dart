import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_fitness_tracker/core/const/color_constants.dart';
import 'package:personal_fitness_tracker/core/router/route_names.dart';
import 'package:personal_fitness_tracker/core/router/route_paths.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';

const Color _kAccentPurple = Color(0xFFC58BF2);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    this.initialTab,
    super.key,
  });

  final String? initialTab;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _authService;
  bool _popUpNotifications = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.user;

    final username = user?.userMetadata?['username'] as String?;
    final displayName =
    (username?.trim().isNotEmpty == true) ? username! : 'User';

    final photoUrl = user?.userMetadata?['avatar_url'] as String?;

    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12,),
                    _UserSummaryRow(
                      name: displayName,
                      photoUrl: photoUrl,
                      onEdit: () {
                        context.go(AppRoutePaths.appProfileEdit);
                      },
                    ),
                    const SizedBox(height: 24),
                    _SectionCard(
                      title: 'Account',
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Personal Data',
                            onTap: () {
                              // go to personal data {weight, height, age}
                            },
                          ),
                          _divider(),
                          _MenuTile(
                            icon: Icons.show_chart_rounded,
                            label: 'Activity History',
                            onTap: () => _toast(context, 'Lịch sử hoạt động'),
                          ),
                          _divider(),
                          _MenuTile(
                            icon: Icons.trending_up_rounded,
                            label: 'Workout Progress',
                            onTap: () => context.go(AppRoutePaths.appWorkouts),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Notification',
                      child: _MenuRow(
                        icon: Icons.notifications_none_rounded,
                        label: 'Pop-up Notification',
                        trailing: Switch(
                          value: _popUpNotifications,
                          onChanged: (v) =>
                              setState(() => _popUpNotifications = v),
                          activeThumbColor: _kAccentPurple,
                          activeTrackColor:
                          _kAccentPurple.withValues(alpha: 0.35),
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Other',
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.mail_outline_rounded,
                            label: 'Contact Us',
                            onTap: () => _toast(context, 'Liên hệ'),
                          ),
                          _divider(),
                          _MenuTile(
                            icon: Icons.shield_outlined,
                            label: 'Privacy Policy',
                            onTap: () => _toast(context, 'Privacy Policy'),
                          ),
                          _divider(),
                          _MenuTile(
                            icon: Icons.settings_outlined,
                            label: 'Settings',
                            onTap: () => context
                                .goNamed(AppRouteNames.appProfileSettings),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — sắp có')),
    );
  }
}


class _UserSummaryRow extends StatelessWidget {
  const _UserSummaryRow({
    required this.name,
    required this.photoUrl,
    required this.onEdit,
  });

  final String name;
  final String? photoUrl;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _Avatar(photoUrl: photoUrl),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          _EditButton(onTap: onEdit),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    const size = 64.0;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFE8EBFF), Color(0xFFF5E8FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _placeholderIcon(),
        )
            : _placeholderIcon(),
      ),
    );
  }

  Widget _placeholderIcon() {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        size: 36,
        color: ColorConstants.buttonColor,
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFFB0BFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF92A3FD).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

Widget _divider() {
  return Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey.shade100,
  );
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _MenuRow(
      icon: icon,
      label: label,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorConstants.icon.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: ColorConstants.icon,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryTextColor,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}