import '../models/session_info.dart';
import '../../data/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<SessionInfo> call({
    required String codigoEmpleado,
    required String password,
  }) async {
    return _authRepository.login(
      codigoEmpleado: codigoEmpleado,
      password: password,
    );
  }
}
