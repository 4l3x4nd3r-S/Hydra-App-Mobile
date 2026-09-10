import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/use_cases/create_os_from_reclamo_use_case.dart';
import '../../../../data/repositories/catalog_repository.dart';

class ReclamoDetalleViewModel extends ChangeNotifier {
  final Reclamo reclamo;
  final CreateOsFromReclamoUseCase _createOsUseCase;
  final CatalogRepository _catalogRepository;

  bool _creandoOs = false;
  bool get creandoOs => _creandoOs;

  String? _ultimoError;
  String? get ultimoError => _ultimoError;

  String? _especialidadRequerida;
  String? get especialidadRequerida => _especialidadRequerida;

  ReclamoDetalleViewModel({
    required this.reclamo,
    required CreateOsFromReclamoUseCase createOsUseCase,
    required CatalogRepository catalogRepository,
  })  : _createOsUseCase = createOsUseCase,
        _catalogRepository = catalogRepository {
    _loadRequiredSpecialty();
  }

  Future<void> _loadRequiredSpecialty() async {
    final formats = await _catalogRepository.getGroup('FORMATO_RECLAMO');
    for (final format in formats) {
      if (format.code == reclamo.formato) {
        _especialidadRequerida = format.relatedCode;
        notifyListeners();
        return;
      }
    }
  }

  List<Cuadrilla> filtrarCuadrillasCompatibles(
    Iterable<Cuadrilla> cuadrillas,
  ) {
    final especialidad = especialidadRequerida;
    if (especialidad == null) return const [];

    return cuadrillas
        .where(
          (cuadrilla) =>
              cuadrilla.especialidad?.trim().toLowerCase() ==
              especialidad.toLowerCase(),
        )
        .toList(growable: false);
  }

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
    
    String detailStr = '';
    if (e.response?.data is Map) {
      final detailRaw = (e.response?.data as Map)['detail'];
      if (detailRaw is String) {
        detailStr = detailRaw;
      } else if (detailRaw is List && detailRaw.isNotEmpty) {
        final firstError = detailRaw.first;
        if (firstError is Map && firstError.containsKey('msg')) {
          detailStr = firstError['msg'].toString();
        } else {
          detailStr = firstError.toString();
        }
      }
    }

    switch (statusCode) {
      case 400:
        return detailStr.isNotEmpty ? detailStr : 'Datos invalidos.';
      case 401:
        return 'Sesion expirada. Inicie sesion nuevamente.';
      case 403:
        return 'No tiene permisos para crear O.S.';
      case 404:
        return 'Recurso no encontrado.';
      case 500:
        return 'Error del servidor. Intente nuevamente.';
      default:
        return detailStr.isNotEmpty
            ? detailStr
            : 'No se pudo crear la O.S. Verifique su conexion.';
    }
  }
}
