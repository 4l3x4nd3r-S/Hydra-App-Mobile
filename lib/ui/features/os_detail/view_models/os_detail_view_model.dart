import 'package:flutter/material.dart';
import '../../../../domain/models/os.dart';

class OsDetailViewModel extends ChangeNotifier {
  final Os os;

  OsDetailViewModel({required this.os}) {
    debugPrint('OsDetailViewModel initialized with os: ${os.id}');
    debugPrint('os.reclamo: ${os.reclamo}');
    debugPrint('os.cuadrilla: ${os.cuadrilla}');
  }

  String get emptyPlaceholder => 'Sin informacion';

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return emptyPlaceholder;
    if (dateStr.length > 19) dateStr = dateStr.substring(0, 19);
    return dateStr.replaceAll('T', ' ');
  }
}
