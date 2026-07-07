import '../models/session_info.dart';
import '../../data/repositories/auth_repository.dart';

class ValidateSessionUseCase {
  final AuthRepository _authRepository;

  ValidateSessionUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<SessionInfo?> call() async {
    return _authRepository.validateSession();
  }
}
