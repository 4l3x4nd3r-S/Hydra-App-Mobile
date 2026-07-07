import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color iconColor;
  final Color textColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}
