import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final int count;
  final String emptyMessage;
  final AppColors c;
  final List<Widget> tiles;
  final IconData? icon;
  final Color? accentColor;
  final String? subtitle;

  const SectionCard({
    super.key,
    required this.title,
    required this.count,
    required this.emptyMessage,
    required this.c,
    required this.tiles,
    this.icon,
    this.accentColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? c.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              color: accent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: accent),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: c.onSurface,
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: c.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (tiles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        emptyMessage,
                        style: TextStyle(
                          color: c.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                else
                  ...tiles,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
