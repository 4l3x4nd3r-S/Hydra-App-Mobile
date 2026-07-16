class ApiEndpoints {
  static const String baseUrl =
      'https://hydra-backend-hx7p.onrender.com/api/v1';
  static const String login = '/auth/login';
  static const String refreshSession = '/auth/refresh';
  static const String ordenesServicio = '/ordenes-servicio';
  static String iniciarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/iniciar';
  static String finalizarOrden(int ordenId) =>
      '/ordenes-servicio/$ordenId/finalizar';
  static const String uploads = '/uploads';
}
