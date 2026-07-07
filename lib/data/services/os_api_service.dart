import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class OsApiService {
  final ApiClient _apiClient;

  OsApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getOrdenes() async {
    return _apiClient.dio.get(ApiEndpoints.ordenesServicio);
  }

  Future<Response> iniciarOrden(int ordenId) async {
    return _apiClient.dio.post(ApiEndpoints.iniciarOrden(ordenId));
  }

  Future<Response> finalizarOrden(int ordenId, Map<String, dynamic> body) async {
    return _apiClient.dio.post(
      ApiEndpoints.finalizarOrden(ordenId),
      data: body,
    );
  }

  Future<Response> uploadImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return _apiClient.dio.post(ApiEndpoints.uploads, data: formData);
  }
}
