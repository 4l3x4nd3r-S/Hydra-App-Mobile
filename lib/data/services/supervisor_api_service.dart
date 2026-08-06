import 'package:dio/dio.dart';
import 'api_client.dart';

class SupervisorApiService {
  final ApiClient _apiClient;

  SupervisorApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getReclamos() async {
    return _apiClient.dio.get('/reclamos');
  }

  Future<Response> crearReclamo(Map<String, dynamic> body) async {
    return _apiClient.dio.post('/reclamos', data: body);
  }

  Future<Response> getOrdenesServicio() async {
    return _apiClient.dio.get('/supervisor/ordenes-servicio');
  }

  Future<Response> getCuadrillas() async {
    return _apiClient.dio.get('/supervisor/cuadrillas');
  }

  Future<Response> getgasfiteros() async {
    return _apiClient.dio.get('/supervisor/tecnicos');
  }

  Future<Response> getgasfiterosDisponibles() async {
    return _apiClient.dio.get('/supervisor/tecnicos-disponibles');
  }

  Future<Response> createOrdenServicioFromReclamo({
    required int reclamoId,
    required int cuadrillaId,
  }) async {
    return _apiClient.dio.post('/supervisor/ordenes-servicio', data: {
      'reclamo_id': reclamoId,
      'cuadrilla_id': cuadrillaId,
      'sector_id': null,
      'fecha_programacion': DateTime.now().toIso8601String(),
    });
  }

  Future<Response> getCuadrilla(int id) async {
    return _apiClient.dio.get('/cuadrillas/$id');
  }

  String _rolBackend(String rol) {
    switch (rol) {
      case 'LIDER':  return 'GASFITERO_PRINCIPAL';
      case 'APOYO':  return 'GASFITERO_APOYO';
      case 'CHOFER': return 'CHOFER_CAMIONETA';
      default:       return rol;
    }
  }

  Future<Response> addPersonal({
    required int cuadrillaId,
    required int usuarioId,
    String rol = 'GASFITERO_APOYO',
  }) async {
    return _apiClient.dio.post(
      '/cuadrillas/$cuadrillaId/personal/$usuarioId',
      queryParameters: {'rol': _rolBackend(rol)},
    );
  }

  Future<Response> removePersonal({
    required int cuadrillaId,
    required int usuarioId,
  }) async {
    return _apiClient.dio.delete(
      '/cuadrillas/$cuadrillaId/personal/$usuarioId',
    );
  }

  Future<Response> updatePersonal({
    required int cuadrillaId,
    required Map<String, dynamic> personal,
  }) async {
    return _apiClient.dio.patch(
      '/cuadrillas/$cuadrillaId/personal',
      data: personal,
    );
  }

  Future<Response> createCuadrilla(Map<String, dynamic> body) async {
    return _apiClient.dio.post('/cuadrillas', data: body);
  }

  Future<Response> deleteCuadrilla(int id) async {
    return _apiClient.dio.delete('/cuadrillas/$id');
  }
}
