import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../domain/models/os.dart';
import '../../../../domain/models/pending_sync_report.dart';
import '../../../../domain/use_cases/start_os_use_case.dart';
import '../../../../domain/use_cases/sync_pending_reports_use_case.dart';

class OsInboxViewModel extends ChangeNotifier {
  final OsRepository _osRepository;
  final AuthRepository _authRepository;
  final StartOsUseCase _startOsUseCase;
  final SyncPendingReportsUseCase _syncPendingReportsUseCase;

  StreamSubscription<void>? _syncSubscription;

  List<Os> _osList = [];
  List<PendingSyncReport> _colaLocal = [];
  bool _sincronizandoManual = false;
  bool _recargandoOs = false;
  String _userName = '';
  String _userRole = '';
  String? _userCode;
  int? _currentUserId;

  List<Os> get osActivas {
    final localOsIds = _colaLocal.map((r) => r.osId).toSet();
    return _osList.where((os) {
      if (localOsIds.contains(os.id)) return false;
      final estado = os.estadoOrden?.toUpperCase();
      if (estado == 'COMPLETADO' || estado == 'ARCHIVADO') return false;
      return true;
    }).toList();
  }

  List<Os> get osArchivadas {
    final localSyncedIds = _colaLocal
        .where((r) => r.status == 'SYNCED')
        .map((r) => r.osId)
        .toSet();
    final remotasArchivadas = _osList.where((os) {
      final estado = os.estadoOrden?.toUpperCase();
      return estado == 'ARCHIVADO' || estado == 'COMPLETADO';
    }).toList();
    final localesArchivadas = _osList.where((os) => localSyncedIds.contains(os.id)).toList();
    final todas = <Os>[];
    final addedIds = <int>{};
    for (final os in remotasArchivadas) {
      if (addedIds.add(os.id)) todas.add(os);
    }
    for (final os in localesArchivadas) {
      if (addedIds.add(os.id)) todas.add(os);
    }
    return todas;
  }

  List<PendingSyncReport> get colaLocal => _colaLocal;
  bool get sincronizandoManual => _sincronizandoManual;
  bool get recargandoOs => _recargandoOs;
  String get userName => _userName;
  String get userRole => _userRole;
  String? get userCode => _userCode;
  int? get currentUserId => _currentUserId;

  /// Retorna true si el usuario logueado es el líder de la cuadrilla de la OS.
  /// Los gasfiteros de apoyo reciben false y solo pueden ver la OS en modo lectura.
  bool isLiderOfOs(Os os) {
    if (_currentUserId == null) return false;
    final liderId = os.cuadrilla?.lider?.id;
    if (liderId == null) return false;
    return liderId == _currentUserId;
  }

  OsInboxViewModel({
    required OsRepository osRepository,
    required AuthRepository authRepository,
    required StartOsUseCase startOsUseCase,
    required SyncPendingReportsUseCase syncPendingReportsUseCase,
  })  : _osRepository = osRepository,
        _authRepository = authRepository,
        _startOsUseCase = startOsUseCase,
        _syncPendingReportsUseCase = syncPendingReportsUseCase {
    _loadColaLocal();
    _cargarOsDelServidor();
    _cargarDatosUsuario();
    _cargarCurrentUserId();

    _syncSubscription = _osRepository.syncStream.listen((_) {
      _loadColaLocal();
      _cargarOsDelServidor();
    });
  }

  Future<void> _loadColaLocal() async {
    _colaLocal = await _osRepository.getPendingReports();
    notifyListeners();
  }

  Future<void> _cargarOsDelServidor() async {
    _osList = await _osRepository.getAssignedOrders();
    notifyListeners();
  }

  Future<void> _cargarDatosUsuario() async {
    final name = await _authRepository.getUserName();
    final role = await _authRepository.getUserRole() ?? 'Gasfitero';
    final code = await _authRepository.getUserCode();
    
    if (name != null) {
      _userName = name;
    }
    
    _userCode = code;
    // Capitalize first letter of role
    _userRole = role.isEmpty ? '' : role[0].toUpperCase() + role.substring(1).toLowerCase();
    notifyListeners();
  }

  Future<void> _cargarCurrentUserId() async {
    final id = await _authRepository.getUserId();
    _currentUserId = id;
    notifyListeners();
  }

  Future<void> refreshOs() async {
    _recargandoOs = true;
    notifyListeners();
    await _cargarOsDelServidor();
    _recargandoOs = false;
    notifyListeners();
  }

  Future<void> startOs(Os os) async {
    await _startOsUseCase(os.id);
    await _loadColaLocal();
    await _cargarOsDelServidor();
  }

  Future<void> syncManual() async {
    _sincronizandoManual = true;
    notifyListeners();
    await _syncPendingReportsUseCase();
    await _loadColaLocal();
    _sincronizandoManual = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    super.dispose();
  }
}
