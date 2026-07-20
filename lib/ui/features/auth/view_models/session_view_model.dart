import 'package:flutter/material.dart';
import '../../../../domain/models/session_info.dart';
import '../../../../domain/use_cases/validate_session_use_case.dart';

class SessionViewModel extends ChangeNotifier {
  final ValidateSessionUseCase _validateSessionUseCase;

  SessionInfo? _session;
  bool _isLoading = true;

  SessionInfo? get session => _session;
  bool get isLoading => _isLoading;

  SessionViewModel({required ValidateSessionUseCase validateSessionUseCase})
      : _validateSessionUseCase = validateSessionUseCase;

  Future<void> validate() async {
    _isLoading = true;
    notifyListeners();
    _session = await _validateSessionUseCase();
    _isLoading = false;
    notifyListeners();
  }
}
