import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/app_settings.dart';

class ThemeModeSelector extends StatelessWidget {
  final AppThemeMode currentMode;
  final ValueChanged<AppThemeMode> onModeChanged;

  const ThemeModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<AppThemeMode>(
          title: Text('light_mode'.tr()),
          secondary: const Icon(Icons.light_mode),
          value: AppThemeMode.light,
          // ignore: deprecated_member_use
          groupValue: currentMode,
          // ignore: deprecated_member_use
          onChanged: (mode) {
            if (mode != null) onModeChanged(mode);
          },
        ),
        RadioListTile<AppThemeMode>(
          title: Text('dark_mode'.tr()),
          secondary: const Icon(Icons.dark_mode),
          value: AppThemeMode.dark,
          // ignore: deprecated_member_use
          groupValue: currentMode,
          // ignore: deprecated_member_use
          onChanged: (mode) {
            if (mode != null) onModeChanged(mode);
          },
        ),
        RadioListTile<AppThemeMode>(
          title: Text('system_default'.tr()),
          secondary: const Icon(Icons.settings_brightness),
          value: AppThemeMode.system,
          // ignore: deprecated_member_use
          groupValue: currentMode,
          // ignore: deprecated_member_use
          onChanged: (mode) {
            if (mode != null) onModeChanged(mode);
          },
        ),
      ],
    );
  }
}
