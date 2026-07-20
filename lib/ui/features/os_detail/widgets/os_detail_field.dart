import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/detail_row.dart';

class OsDetailField extends StatelessWidget {
  final String label;
  final String? value;
  final AppColors c;

  const OsDetailField({
    super.key,
    required this.label,
    required this.value,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
        (value != null && value!.isNotEmpty) ? value! : 'Sin informacion';
    return DetailRow(
      label: label,
      value: displayValue,
      c: c,
    );
  }
}
