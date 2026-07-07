import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final AppColors c;

  const InfoCard({
    super.key,
    required this.title,
    required this.children,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: c.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: c.primary,
                    letterSpacing: 1)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
