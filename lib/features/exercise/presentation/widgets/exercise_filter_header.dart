import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';
import 'package:fit_me/features/exercise/domain/entities/muscle_group.dart';

class ExerciseFilterHeader extends StatelessWidget {
  final MuscleGroup? selectedGroup;
  final ValueChanged<MuscleGroup?> onGroupSelected;

  const ExerciseFilterHeader({
    super.key,
    required this.selectedGroup,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildTab(context, null, 'all'.tr()),
          const SizedBox(width: 12),
          for (final group in MuscleGroup.values) ...[
            _buildTab(context, group, group.translationKey.tr()),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, MuscleGroup? group, String label) {
    final isSelected = selectedGroup == group;

    return GestureDetector(
      onTap: () => onGroupSelected(group),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? ColorConstants.iconColor
              : ColorConstants.textSecondaryColor.withValues(alpha: 0.2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? ColorConstants.buttonTextColor
                : ColorConstants.textSecondaryColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
