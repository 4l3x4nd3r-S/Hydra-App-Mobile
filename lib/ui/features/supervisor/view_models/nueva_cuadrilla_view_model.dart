import 'package:flutter/material.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/models/gasfitero.dart';

class EspecialidadOption {
  final String value;
  final String label;
  const EspecialidadOption(this.value, this.label);
}

class NuevaCuadrillaViewModel extends ChangeNotifier {
  final SupervisorRepository _supervisorRepository;
  final CatalogRepository _catalogRepository;

  EspecialidadOption? _especialidad;
  EspecialidadOption? get especialidad => _especialidad;
  List<EspecialidadOption> _especialidades = const [];
  List<EspecialidadOption> get especialidades =>
      List.unmodifiable(_especialidades);

  List<Gasfitero> _gasfiteros = [];
  List<Gasfitero> get gasfiteros => _gasfiteros;

  Gasfitero? _lider;
  Gasfitero? get lider => _lider;

  List<Gasfitero> _apoyos = [];
  List<Gasfitero> get apoyos => _apoyos;

  Gasfitero? _chofer;
  Gasfitero? get chofer => _chofer;

  bool _submitting = false;
  bool get submitting => _submitting;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool get canSubmit =>
      _especialidad != null && _lider != null && cantidadIntegrantes >= 2;

  int get cantidadIntegrantes => <int>{
        if (_lider != null) _lider!.id,
        ..._apoyos.map((integrante) => integrante.id),
        if (_chofer != null) _chofer!.id,
      }.length;

  bool _loadingGasfiteros = true;
  bool get loadingGasfiteros => _loadingGasfiteros;

  NuevaCuadrillaViewModel({
    required SupervisorRepository supervisorRepository,
    required CatalogRepository catalogRepository,
  })  : _supervisorRepository = supervisorRepository,
        _catalogRepository = catalogRepository {
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    _loadingGasfiteros = true;
    notifyListeners();
    try {
      final personalFuture = _supervisorRepository.getgasfiterosDisponibles();
      final catalogFuture =
          _catalogRepository.getGroup('ESPECIALIDAD_CUADRILLA');
      _gasfiteros = await personalFuture;
      final catalogOptions = await catalogFuture;
      _especialidades = catalogOptions
          .map((option) => EspecialidadOption(option.code, option.label))
          .toList(growable: false);
      if (_especialidades.isNotEmpty) {
        final defaultCode = catalogOptions
            .firstWhere((option) => option.isDefault,
                orElse: () => catalogOptions.first)
            .code;
        _especialidad = _especialidades.firstWhere(
          (option) => option.value == defaultCode,
          orElse: () => _especialidades.first,
        );
      }
    } catch (_) {
      _errorMsg = 'No se pudo cargar la configuración de cuadrillas';
    } finally {
      _loadingGasfiteros = false;
      notifyListeners();
    }
  }

  List<Gasfitero> get gasfiterosDisponiblesParaRol {
    final idsYaSeleccionados = <int>{};
    if (_lider != null) idsYaSeleccionados.add(_lider!.id);
    idsYaSeleccionados.addAll(_apoyos.map((t) => t.id));

    return _gasfiteros.where((t) {
      if (idsYaSeleccionados.contains(t.id)) return false;
      return t.puedeSerGasfitero;
    }).toList();
  }

  List<Gasfitero> get gasfiterosDisponiblesParaApoyos {
    final idsEnOtrosRoles = <int>{};
    if (_lider != null) idsEnOtrosRoles.add(_lider!.id);

    return _gasfiteros.where((t) {
      if (idsEnOtrosRoles.contains(t.id)) return false;
      return t.puedeSerGasfitero;
    }).toList();
  }

  List<Gasfitero> get choferesDisponibles {
    return _gasfiteros.where((t) => t.puedeSerChofer).toList();
  }

  void setEspecialidad(EspecialidadOption opcion) {
    if (_especialidad?.value != opcion.value) {
      _especialidad = opcion;
      _errorMsg = null;
      notifyListeners();
    }
  }

  void setLider(Gasfitero? t) {
    _lider = t;
    _errorMsg = null;
    notifyListeners();
  }

  void toggleApoyo(Gasfitero t) {
    final idx = _apoyos.indexWhere((e) => e.id == t.id);
    if (idx >= 0) {
      _apoyos.removeAt(idx);
    } else {
      _apoyos.add(t);
    }
    _errorMsg = null;
    notifyListeners();
  }

  void setApoyos(Iterable<Gasfitero> apoyos) {
    final idsAgregados = <int>{};
    _apoyos = apoyos
        .where((apoyo) => apoyo.id != _lider?.id && idsAgregados.add(apoyo.id))
        .toList();
    _errorMsg = null;
    notifyListeners();
  }

  void setChofer(Gasfitero? t) {
    _chofer = t;
    _errorMsg = null;
    notifyListeners();
  }

  bool validar() {
    if (_lider == null) {
      _errorMsg = 'Debe asignar un Gasfitero Principal';
      notifyListeners();
      return false;
    }
    if (cantidadIntegrantes < 2) {
      _errorMsg = 'La cuadrilla debe tener al menos 2 integrantes';
      notifyListeners();
      return false;
    }
    _errorMsg = null;
    return true;
  }

  Future<bool> submit() async {
    if (!validar()) return false;

    _submitting = true;
    _errorMsg = null;
    notifyListeners();

    try {
      await _supervisorRepository.createCuadrilla(
        especialidad: _especialidad!.value,
        liderId: _lider!.id,
        apoyosIds: _apoyos.map((t) => t.id).toList(),
        choferId: _chofer?.id,
      );
      _submitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _submitting = false;
      _errorMsg = 'Error al crear la cuadrilla';
      notifyListeners();
      return false;
    }
  }
}
