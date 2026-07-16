class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.16:8000/api/v1';
  static const String login = '/auth/login';
  static const String refreshSession = '/auth/refresh';
  static const String ordenesServicio = '/ordenes-servicio';
  static String iniciarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/iniciar';
  static String finalizarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/finalizar';
  static const String uploads = '/uploads';
}
