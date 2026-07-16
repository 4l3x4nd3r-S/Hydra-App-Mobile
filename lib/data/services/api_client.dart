import 'package:dio/dio.dart';
import 'api_endpoints.dart';
import 'session_storage_service.dart';
import '../../ui/core/services/session_event_bus.dart';

class ApiClient {
  final Dio dio;
  final SessionEventBus _sessionEventBus;
  final SessionStorageService _sessionStorage;
  late final Dio _refreshClient;
  Future<String?>? _refreshInProgress;

  ApiClient({
    required String baseUrl,
    required SessionStorageService sessionStorage,
    required SessionEventBus sessionEventBus,
  })  : _sessionEventBus = sessionEventBus,
        _sessionStorage = sessionStorage,
        dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 45),
          receiveTimeout: const Duration(seconds: 45),
        )) {
    _refreshClient = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await sessionStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) async {
        final request = e.requestOptions;
        final canRefresh = e.response?.statusCode == 401 &&
            request.extra['sessionRetry'] != true &&
            request.path != ApiEndpoints.login &&
            request.path != ApiEndpoints.refreshSession;

        if (canRefresh) {
          final accessToken = await _refreshAccessToken();
          if (accessToken != null) {
            request.extra['sessionRetry'] = true;
            request.headers['Authorization'] = 'Bearer $accessToken';
            try {
              final response = await dio.fetch<dynamic>(request);
              return handler.resolve(response);
            } on DioException catch (retryError) {
              if (retryError.response?.statusCode != 401) {
                return handler.next(retryError);
              }
            }
          }

          _sessionEventBus.notifySessionExpired();
        }
        return handler.next(e);
      },
    ));
  }

  Future<String?> _refreshAccessToken() async {
    final currentRefresh = _refreshInProgress;
    if (currentRefresh != null) return currentRefresh;

    final refresh = _performRefresh();
    _refreshInProgress = refresh;
    try {
      return await refresh;
    } finally {
      _refreshInProgress = null;
    }
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _sessionStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshClient.post<Map<String, dynamic>>(
        ApiEndpoints.refreshSession,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      final accessToken = data?['access_token'] as String?;
      final rotatedRefreshToken = data?['refresh_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) return null;

      await _sessionStorage.saveToken(accessToken);
      if (rotatedRefreshToken != null && rotatedRefreshToken.isNotEmpty) {
        await _sessionStorage.saveRefreshToken(rotatedRefreshToken);
      }
      return accessToken;
    } on DioException {
      return null;
    }
  }
}
