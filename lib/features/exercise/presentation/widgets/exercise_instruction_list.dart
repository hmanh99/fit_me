import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fit_me/core/constants/color_constants.dart';

class ExerciseInstructionList extends StatelessWidget {
  final List<String> instructions;

  const ExerciseInstructionList({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    if (instructions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorConstants.socialBorderColor),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: ColorConstants.buttonColor,
              ),
              const SizedBox(width: 8),
              Text(
                'instructions'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(instructions.length, (index) {
            final isLast = index == instructions.length - 1;
            return _InstructionStep(
              stepNumber: index + 1,
              text: instructions[index],
              showConnector: !isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int stepNumber;
  final String text;
  final bool showConnector;

  const _InstructionStep({
    required this.stepNumber,
    required this.text,
    required this.showConnector,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: ColorConstants.buttonColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$stepNumber',
                  style: const TextStyle(
                    color: ColorConstants.buttonTextColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (showConnector)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: ColorConstants.buttonColor.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showConnector ? 16 : 0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: ColorConstants.textPrimaryColor,
                  height: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
