import 'package:flutter/material.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/os.dart';

class OsDetailViewModel extends ChangeNotifier {
  final Os os;
  final CatalogRepository? _catalogRepository;

  String _tipoProblemaLabel;
  bool _disposed = false;

  OsDetailViewModel({required this.os, CatalogRepository? catalogRepository})
      : _catalogRepository = catalogRepository,
        _tipoProblemaLabel = os.reclamo?.tipoProblema?.trim() ?? '' {
    debugPrint('OsDetailViewModel initialized with os: ${os.id}');
    _cargarTipoProblemaLabel();
  }

  String get emptyPlaceholder => 'Sin informacion';

  /// Código del tipo de problema acompañado de su descripción del catálogo.
  String get tipoProblemaLabel => _tipoProblemaLabel;

  Future<void> _cargarTipoProblemaLabel() async {
    final repository = _catalogRepository;
    if (repository == null) return;
    final label = await repository.tipoProblemaLabel(os.reclamo?.tipoProblema);
    if (_disposed || label == _tipoProblemaLabel) return;
    _tipoProblemaLabel = label;
    notifyListeners();
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return emptyPlaceholder;
    if (dateStr.length > 19) dateStr = dateStr.substring(0, 19);
    return dateStr.replaceAll('T', ' ');
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
