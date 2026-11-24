import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../domain/models/session_info.dart';
import '../../../../domain/use_cases/login_use_case.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorMsg;

  bool get loading => _loading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMsg => _errorMsg;

  LoginViewModel({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    _errorMsg = null;
    notifyListeners();
  }

  Future<SessionInfo?> login() async {
    final codigo = codigoController.text.trim().toUpperCase();
    final password = passController.text.trim();
    if (codigo.isEmpty || password.isEmpty) {
      _errorMsg = 'Ingrese codigo de empleado y contrasena';
      notifyListeners();
      return null;
    }

    _loading = true;
    _errorMsg = null;
    notifyListeners();

    try {
      final session = await _loginUseCase(
        codigoEmpleado: codigo,
        password: password,
      );
      return session;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 404 ||
          e.response?.statusCode == 400) {
        _errorMsg = 'Credenciales inválidas.';
      } else {
        _errorMsg = 'Error de conexión. Intente nuevamente.';
      }
      notifyListeners();
      return null;
    } catch (e) {
      _errorMsg = 'Credenciales inválidas.';
      notifyListeners();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    codigoController.dispose();
    passController.dispose();
    super.dispose();
  }
}
