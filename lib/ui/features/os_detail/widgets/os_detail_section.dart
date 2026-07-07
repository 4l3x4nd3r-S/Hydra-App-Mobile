import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/detail_row.dart';

class OsDetailSection extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> fields;
  final List<Widget>? extraActions;
  final AppColors c;

  const OsDetailSection({
    super.key,
    required this.title,
    required this.fields,
    this.extraActions,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final field in fields) {
      children.add(
        DetailRow(
          label: field.key,
          value: field.value.isNotEmpty ? field.value : 'Sin informacion',
          c: c,
        ),
      );
    }
    if (extraActions != null && extraActions!.isNotEmpty) {
      children.add(const SizedBox(height: 8));
    }
    if (extraActions != null) {
      children.addAll(extraActions!);
    }

    return InfoCard(
      title: title.toUpperCase(),
      children: children,
      c: c,
    );
  }
}
