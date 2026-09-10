import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class OsApiService {
  final ApiClient _apiClient;

  OsApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getOrdenes() async {
    return _apiClient.dio.get(ApiEndpoints.ordenesServicio);
  }

  Future<Response> getOrden(int ordenId) async {
    return _apiClient.dio.get('${ApiEndpoints.ordenesServicio}/$ordenId');
  }

  Future<Response> iniciarOrden(int ordenId) async {
    return _apiClient.dio.post(ApiEndpoints.iniciarOrden(ordenId));
  }

  Future<Response> finalizarOrden(
      int ordenId, Map<String, dynamic> body) async {
    return _apiClient.dio.post(
      ApiEndpoints.finalizarOrden(ordenId),
      data: body,
    );
  }

  Future<Response> uploadImage(String filePath, {int? osId, String? categoria}) async {
    final Map<String, dynamic> formDataMap = {
      'file': await MultipartFile.fromFile(filePath),
    };
    if (osId != null) {
      formDataMap['os_id'] = osId.toString();
    }
    if (categoria != null) {
      formDataMap['categoria'] = categoria;
    }
    final formData = FormData.fromMap(formDataMap);
    
    return _apiClient.dio.post(
      ApiEndpoints.uploads,
      data: formData,
      options: Options(
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
  }
}
