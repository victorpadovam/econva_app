import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: w * 0.045, height: 2, color: const Color(0xFF9147E8)),
        SizedBox(width: w * 0.025),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: const Color(0xFF9147E8),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
          ),
        ),
      ],
    );
  }
}
