import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/gasfitero.dart';

class SupervisorViewModel extends ChangeNotifier {
  final SupervisorRepository _supervisorRepository;
  final AuthRepository _authRepository;
  final CatalogRepository? _catalogRepository;

  Timer? _refreshTimer;
  String _userName = '';
  String _userRole = '';
  String? _userCode;

  List<Reclamo> _reclamos = [];
  List<Cuadrilla> _cuadrillas = [];
  List<Gasfitero> _gasfiteros = [];
  List<Gasfitero> _gasfiterosDisponibles = [];
  Map<String, String> _descripcionesTipoProblema = const {};
  bool _loadingReclamos = false;
  bool _loadingCuadrillas = false;
  bool _loadinggasfiteros = false;
  String? _errorMessageReclamos;

  List<Reclamo> get reclamos => _reclamos;
  List<Cuadrilla> get cuadrillas => _cuadrillas;
  List<Gasfitero> get gasfiteros => _gasfiteros;
  List<Gasfitero> get gasfiterosDisponibles => _gasfiterosDisponibles;
  List<Gasfitero> get personalMantenimientoOrdenado =>
      List.unmodifiable(_gasfiteros);

  bool get loadingReclamos => _loadingReclamos;
  bool get loadingCuadrillas => _loadingCuadrillas;
  bool get loadinggasfiteros => _loadinggasfiteros;
  String get userName => _userName;
  String get userRole => _userRole;
  String? get userCode => _userCode;
  String? get errorMessageReclamos => _errorMessageReclamos;
  String? descripcionTipoProblema(String? codigo) =>
      codigo == null ? null : _descripcionesTipoProblema[codigo];

  List<Reclamo> get reclamosPendientes =>
      _reclamos.where((r) => _normEstado(r.estado) == 'PENDIENTE').toList();

  List<Reclamo> get reclamosAsignados => _reclamos.where((r) {
        final e = _normEstado(r.estado);
        return e == 'ASIGNADO' || e == 'EN_PROCESO';
      }).toList();

  List<Reclamo> get reclamosCerrados => _reclamos.where((r) {
        final e = _normEstado(r.estado);
        return e == 'ATENDIDO' ||
            e == 'RECHAZADO' ||
            e == 'COMPLETADO' ||
            e == 'CERRADO';
      }).toList();

  String _normEstado(String? e) =>
      (e ?? 'PENDIENTE').toUpperCase().replaceAll(' ', '_');

  SupervisorViewModel({
    required SupervisorRepository supervisorRepository,
    required AuthRepository authRepository,
    CatalogRepository? catalogRepository,
  })  : _supervisorRepository = supervisorRepository,
        _authRepository = authRepository,
        _catalogRepository = catalogRepository {
    _cargarNombreUsuario();
    cargarTodo();
    _refreshTimer = Timer.periodic(
        const Duration(seconds: 30), (_) => cargarTodo(silent: true));
  }

  Future<void> _cargarNombreUsuario() async {
    final name = await _authRepository.getUserName();
    final role = await _authRepository.getUserRole() ?? 'Supervisor';
    final code = await _authRepository.getUserCode();

    if (name != null) {
      _userName = name;
    }
    _userCode = code;
    // Capitalize first letter of role
    _userRole = role.isEmpty
        ? ''
        : role[0].toUpperCase() + role.substring(1).toLowerCase();

    notifyListeners();
  }

  Future<void> cargarTodo({bool silent = false}) async {
    await Future.wait([
      _cargarReclamos(silent: silent),
      _cargarCuadrillas(silent: silent),
      _cargargasfiteros(silent: silent),
      _cargarGasfiterosDisponibles(silent: silent),
      _cargarDescripcionesTipoProblema(),
    ]);
  }

  Future<void> _cargarDescripcionesTipoProblema() async {
    final repository = _catalogRepository;
    if (repository == null) return;
    try {
      final options = await repository.getGroup('TIPO_PROBLEMA');
      _descripcionesTipoProblema = {
        for (final option in options)
          if (option.description?.trim().isNotEmpty ?? false)
            option.code: option.description!.trim(),
      };
    } catch (e) {
      debugPrint('Error cargando descripciones de tipos de problema: $e');
    }
  }

  Future<void> _cargarReclamos({bool silent = false}) async {
    if (!silent) {
      _loadingReclamos = true;
      _errorMessageReclamos = null;
      notifyListeners();
    }
    try {
      _reclamos = await _supervisorRepository.getReclamos();
    } on DioException catch (e) {
      _errorMessageReclamos = _mapDioError(e);
      _reclamos = [];
      debugPrint('Error cargando reclamos: $e');
    } catch (e, st) {
      _errorMessageReclamos = 'Error inesperado al cargar reclamos.';
      _reclamos = [];
      debugPrint('Error inesperado: $e\n$st');
    } finally {
      if (!silent) {
        _loadingReclamos = false;
      }
      notifyListeners();
    }
  }

  Future<void> _cargarCuadrillas({bool silent = false}) async {
    if (!silent) {
      _loadingCuadrillas = true;
      notifyListeners();
    }
    _cuadrillas = await _supervisorRepository.getCuadrillas();
    if (!silent) {
      _loadingCuadrillas = false;
    }
    notifyListeners();
  }

  Future<void> _cargargasfiteros({bool silent = false}) async {
    if (!silent) {
      _loadinggasfiteros = true;
      notifyListeners();
    }
    _gasfiteros = await _supervisorRepository.getgasfiteros();
    if (!silent) {
      _loadinggasfiteros = false;
    }
    notifyListeners();
  }

  Future<void> _cargarGasfiterosDisponibles({bool silent = false}) async {
    _gasfiterosDisponibles =
        await _supervisorRepository.getgasfiterosDisponibles();
    if (!silent) {
      notifyListeners();
    }
  }

  String _mapDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return 'Sesion expirada. Inicie sesion nuevamente.';
      case 403:
        return 'No tiene permisos para ver reclamos.';
      case 500:
        return 'Error del servidor. Intente nuevamente.';
      default:
        return 'No se pudieron cargar los reclamos. Verifique su conexion.';
    }
  }

  Future<bool> crearCuadrilla({
    required String especialidad,
    int? liderId,
    List<int> apoyosIds = const [],
    int? choferId,
  }) async {
    try {
      final nueva = await _supervisorRepository.createCuadrilla(
        especialidad: especialidad,
        liderId: liderId,
        apoyosIds: apoyosIds,
        choferId: choferId,
      );
      _cuadrillas = [..._cuadrillas, nueva];
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
