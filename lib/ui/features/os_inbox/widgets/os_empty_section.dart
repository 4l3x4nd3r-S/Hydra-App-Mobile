import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';

class OsEmptySection extends StatelessWidget {
  final String message;
  final AppColors c;

  const OsEmptySection({
    super.key,
    required this.message,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.assignment_outlined,
      message: message,
      iconColor: c.onSurfaceVariant,
      textColor: c.onSurfaceVariant,
    );
  }
}
