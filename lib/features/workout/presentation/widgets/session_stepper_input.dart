import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepperInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final double step;
  final bool isDecimal;

  const StepperInput({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.step,
    required this.isDecimal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF92A3FD), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        //  decrement button
        IconButton(
          onPressed: () {
            final current = double.tryParse(controller.text) ?? 0.0;
            final next = (current - step).clamp(0.0, 999.0);
            controller.text = isDecimal
                ? next.toStringAsFixed(1)
                : next.toInt().toString();
          },
          icon: const Icon(Icons.remove_circle_outline_rounded),
          color: Colors.red.shade300,
        ),

        // text field input
        SizedBox(
          width: 70,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(isDecimal ? r'^\d*\.?\d*' : r'^\d*'),
              ),
            ],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF92A3FD),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),

        //  increment button
        IconButton(
          onPressed: () {
            final current = double.tryParse(controller.text) ?? 0.0;
            final next = current + step;
            controller.text = isDecimal
                ? next.toStringAsFixed(1)
                : next.toInt().toString();
          },
          icon: const Icon(Icons.add_circle_outline_rounded),
          color: const Color(0xFF92A3FD),
        ),
      ],
    );
  }
}
