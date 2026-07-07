import 'package:dio/dio.dart';
import 'api_client.dart';

class CatastroApiService {
  final ApiClient _apiClient;

  CatastroApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getSectores() async {
    return _apiClient.dio.get('/sectores');
  }

  Future<Response> getElementosRed() async {
    return _apiClient.dio.get('/supervisor/elementos-red');
  }

  Future<Response> getPuntosPresion() async {
    return _apiClient.dio.get('/puntos-presion');
  }

  Future<Response> getUltimoRegistroPresion(int puntoId) async {
    return _apiClient.dio.get('/registros-presion/punto/$puntoId/ultimo');
  }
}
