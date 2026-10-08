import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final height = (h * 0.07).clamp(54.0, 72.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2.4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA463F7), Color(0xFF6D28C4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2.4),
          onTap: onPressed,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
