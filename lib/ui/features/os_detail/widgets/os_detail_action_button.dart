import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OsDetailActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final AppColors c;
  final bool hasError;

  const OsDetailActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.c,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: hasError ? const Color(0xFFFEF2F2) : Colors.transparent,
            foregroundColor: hasError ? const Color(0xFFDC2626) : c.primary,
            side: BorderSide(
                color: hasError ? const Color(0xFFDC2626) : c.primary.withValues(alpha: 0.4)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
