import 'api_client.dart';
import 'api_endpoints.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, dynamic>> login({
    required String codigoEmpleado,
    required String password,
  }) async {
    final response = await _apiClient.dio.post(
      ApiEndpoints.login,
      data: {
        'codigo_empleado': codigoEmpleado,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> me() async {
    final response = await _apiClient.dio.get('/auth/me');
    return response.data as Map<String, dynamic>;
  }
}
