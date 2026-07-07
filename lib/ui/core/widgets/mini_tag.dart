import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MiniTag extends StatelessWidget {
  final String text;
  final AppColors c;

  const MiniTag({super.key, required this.text, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.border),
      ),
      child: Text(text,
          style: TextStyle(
              color: c.onSurfaceVariant, fontSize: 10)),
    );
  }
}
