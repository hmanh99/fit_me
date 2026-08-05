import 'package:flutter/material.dart';

import '../../../../core/constants/app_languages.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguageCode;
  final ValueChanged<String> onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: AppLanguages.supportedLanguages.length,
      itemBuilder: (context, index) {
        final language = AppLanguages.supportedLanguages[index];
        final isSelected = language.code == currentLanguageCode;
        return ListTile(
          leading: isSelected
              ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
              : const SizedBox(width: 24),
          title: Text(language.nativeName),
          subtitle: Text(language.name),
          trailing: Text(language.code.toUpperCase()),
          onTap: () => onLanguageSelected(language.code),
        );
      },
    );
  }
}
