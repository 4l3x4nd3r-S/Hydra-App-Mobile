import 'package:dio/dio.dart';
import '../services/auth_api_service.dart';
import '../services/session_storage_service.dart';
import '../../domain/models/session_info.dart';

class AuthRepository {
  final AuthApiService _authApiService;
  final SessionStorageService _sessionStorage;

  AuthRepository({
    required AuthApiService authApiService,
    required SessionStorageService sessionStorage,
  })  : _authApiService = authApiService,
        _sessionStorage = sessionStorage;

  Future<SessionInfo> login({
    required String codigoEmpleado,
    required String password,
  }) async {
    final data = await _authApiService.login(
      codigoEmpleado: codigoEmpleado,
      password: password,
    );

    final String token = data['access_token'] as String;
    final String? refreshToken = data['refresh_token'] as String?;
    final userJson = data['user'] as Map<String, dynamic>?;
    if (userJson == null ||
        userJson['nombre'] is! String ||
        userJson['rol'] is! String) {
      throw StateError('El servidor devolvió una sesión incompleta.');
    }
    final String nombre = userJson['nombre'] as String;
    final String rol = userJson['rol'] as String;
    final int? userId = userJson['id'] as int?;

    await _sessionStorage.saveToken(token);
    if (refreshToken != null) {
      await _sessionStorage.saveRefreshToken(refreshToken);
    }
    await _sessionStorage.saveUserName(nombre);
    await _sessionStorage.saveUserRole(rol);
    await _sessionStorage.saveUserCode(codigoEmpleado);
    if (userId != null) {
      await _sessionStorage.saveUserId(userId);
    }

    return SessionInfo(valido: true, rol: rol, nombre: nombre);
  }

  Future<SessionInfo?> validateSession() async {
    final hasSession = await _sessionStorage.hasSession();
    if (!hasSession) return null;

    try {
      final userJson = await _authApiService.me();
      final rol = userJson['rol'] as String?;
      if (rol == null || rol.isEmpty) {
        await _sessionStorage.clearSession();
        return null;
      }
      final nombre =
          userJson['nombre'] as String? ?? await _sessionStorage.getUserName();
      final userId = userJson['id'] as int?;
      final codigoEmpleado = userJson['codigo_empleado'] as String?;

      await _sessionStorage.saveUserRole(rol);
      if (nombre != null) {
        await _sessionStorage.saveUserName(nombre);
      }
      if (userId != null) {
        await _sessionStorage.saveUserId(userId);
      }
      if (codigoEmpleado != null) {
        await _sessionStorage.saveUserCode(codigoEmpleado);
      }

      return SessionInfo(valido: true, rol: rol, nombre: nombre);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _sessionStorage.clearSession();
        return null;
      }
      final rol = await _sessionStorage.getUserRole();
      if (rol == null || rol.isEmpty) {
        await _sessionStorage.clearSession();
        return null;
      }
      return SessionInfo(valido: true, rol: rol, nombre: null);
    }
  }

  Future<void> logout() async {
    await _sessionStorage.clearSession();
  }

  Future<String?> getUserName() async {
    return _sessionStorage.getUserName();
  }

  Future<int?> getUserId() async {
    return _sessionStorage.getUserId();
  }

  Future<String?> getUserRole() async {
    return _sessionStorage.getUserRole();
  }

  Future<String?> getUserCode() async {
    return _sessionStorage.getUserCode();
  }
}
