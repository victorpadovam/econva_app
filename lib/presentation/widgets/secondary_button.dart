import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFB3B1C2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFB3B1C2),
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward, size: 20, color: Color(0xFFB3B1C2)),
        ],
      ),
    );
  }
}
