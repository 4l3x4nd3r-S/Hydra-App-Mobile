import 'package:dio/dio.dart';
import 'session_storage_service.dart';
import '../../ui/core/services/session_event_bus.dart';

class ApiClient {
  final Dio dio;
  final SessionEventBus _sessionEventBus;

  ApiClient({
    required String baseUrl,
    required SessionStorageService sessionStorage,
    required SessionEventBus sessionEventBus,
  })  : _sessionEventBus = sessionEventBus,
        dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await sessionStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          _sessionEventBus.notifySessionExpired();
        }
        return handler.next(e);
      },
    ));
  }
}
