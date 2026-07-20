import 'package:dio/dio.dart';

import 'api_client.dart';

class CatalogApiService {
  CatalogApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Response> getOperationalCatalog() {
    return _apiClient.dio.get('/catalogos/operacion');
  }
}
