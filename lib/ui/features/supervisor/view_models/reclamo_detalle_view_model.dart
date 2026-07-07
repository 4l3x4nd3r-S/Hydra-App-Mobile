import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/use_cases/create_os_from_reclamo_use_case.dart';

class ReclamoDetalleViewModel extends ChangeNotifier {
  final Reclamo reclamo;
  final CreateOsFromReclamoUseCase _createOsUseCase;

  bool _creandoOs = false;
  bool get creandoOs => _creandoOs;

  String? _ultimoError;
  String? get ultimoError => _ultimoError;

  ReclamoDetalleViewModel({
    required this.reclamo,
    required CreateOsFromReclamoUseCase createOsUseCase,
  }) : _createOsUseCase = createOsUseCase;

  Future<bool> crearOsFromReclamo(int cuadrillaId) async {
    _creandoOs = true;
    _ultimoError = null;
    notifyListeners();
    try {
      await _createOsUseCase(
        reclamoId: reclamo.id,
        cuadrillaId: cuadrillaId,
      );
      return true;
    } on DioException catch (e) {
      _ultimoError = _mapDioError(e);
      debugPrint('Error creando OS: $e');
      return false;
    } catch (e, st) {
      _ultimoError = 'Error inesperado al crear la O.S.';
      debugPrint('Error inesperado: $e\n$st');
      return false;
    } finally {
      _creandoOs = false;
      notifyListeners();
    }
  }

  String _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final detail = e.response?.data is Map
        ? (e.response?.data as Map)['detail'] as String? ?? ''
        : '';

    switch (statusCode) {
      case 400:
        return detail.isNotEmpty ? detail : 'Datos invalidos.';
      case 401:
        return 'Sesion expirada. Inicie sesion nuevamente.';
      case 403:
        return 'No tiene permisos para crear O.S.';
      case 404:
        return 'Recurso no encontrado.';
      case 500:
        return 'Error del servidor. Intente nuevamente.';
      default:
        return detail.isNotEmpty
            ? detail
            : 'No se pudo crear la O.S. Verifique su conexion.';
    }
  }
}
