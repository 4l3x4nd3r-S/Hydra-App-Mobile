import 'app_environment.dart';

class ApiEndpoints {
  static const String baseUrl = AppEnvironment.apiBaseUrl;
  static const String login = '/auth/login';
  static const String refreshSession = '/auth/refresh';
  static const String ordenesServicio = '/ordenes-servicio';
  static String iniciarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/iniciar';
  static String finalizarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/finalizar';
  static const String uploads = '/uploads/evidencias';
}
