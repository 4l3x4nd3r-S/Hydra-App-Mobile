import 'package:flutter/material.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/gasfitero.dart';

class EspecialidadOption {
  final String value;
  final String label;
  const EspecialidadOption(this.value, this.label);

  static const distribucion = EspecialidadOption('Agua', 'Área de Distribución');
  static const mantenimiento = EspecialidadOption('Desagüe', 'Área de Mantenimiento');
  static const List<EspecialidadOption> all = [distribucion, mantenimiento];
}

class NuevaCuadrillaViewModel extends ChangeNotifier {
  final SupervisorRepository _supervisorRepository;

  final TextEditingController nombreController = TextEditingController();

  EspecialidadOption _especialidad = EspecialidadOption.distribucion;
  EspecialidadOption get especialidad => _especialidad;

  List<Gasfitero> _gasfiteros = [];
  List<Gasfitero> get gasfiteros => _gasfiteros;

  Gasfitero? _lider;
  Gasfitero? get lider => _lider;

  List<Gasfitero> _apoyos = [];
  List<Gasfitero> get apoyos => _apoyos;

  Gasfitero? _chofer;
  Gasfitero? get chofer => _chofer;

  Gasfitero? _operador;
  Gasfitero? get operador => _operador;

  bool _submitting = false;
  bool get submitting => _submitting;

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  bool get canSubmit =>
      nombreController.text.trim().isNotEmpty && _lider != null;

  bool _loadingGasfiteros = true;
  bool get loadingGasfiteros => _loadingGasfiteros;

  NuevaCuadrillaViewModel({required SupervisorRepository supervisorRepository})
      : _supervisorRepository = supervisorRepository {
    nombreController.addListener(notifyListeners);
    _cargargasfiteros();
  }

  Future<void> _cargargasfiteros() async {
    _loadingGasfiteros = true;
    notifyListeners();
    _gasfiteros = await _supervisorRepository.getgasfiterosDisponibles();
    _loadingGasfiteros = false;
    notifyListeners();
  }

  String get _areaFiltro => _especialidad.value == 'Agua' ? 'DISTRIBUCION' : 'MANTENIMIENTO';

  List<Gasfitero> get gasfiterosDisponiblesParaRol {
    final idsYaSeleccionados = <int>{};
    if (_lider != null) idsYaSeleccionados.add(_lider!.id);
    idsYaSeleccionados.addAll(_apoyos.map((t) => t.id));

    return _gasfiteros
        .where((t) {
          if ((t.area ?? '').toUpperCase() != _areaFiltro) return false;
          if (idsYaSeleccionados.contains(t.id)) return false;
          final c = (t.cargo ?? '').toUpperCase();
          if (c.contains('CHOFER') || c.contains('OPERADOR')) return false;
          return true;
        })
        .toList();
  }

  List<Gasfitero> get gasfiterosDisponiblesParaApoyos {
    final idsEnOtrosRoles = <int>{};
    if (_lider != null) idsEnOtrosRoles.add(_lider!.id);

    return _gasfiteros
        .where((t) {
          if ((t.area ?? '').toUpperCase() != _areaFiltro) return false;
          if (idsEnOtrosRoles.contains(t.id)) return false;
          final c = (t.cargo ?? '').toUpperCase();
          if (c.contains('CHOFER') || c.contains('OPERADOR')) return false;
          return true;
        })
        .toList();
  }

  List<Gasfitero> get choferesDisponibles {
    return _gasfiteros.where((t) {
      if ((t.area ?? '').toUpperCase() != _areaFiltro) return false;
      return (t.cargo ?? '').toUpperCase().contains('CHOFER');
    }).toList();
  }

  List<Gasfitero> get operadoresDisponibles {
    return _gasfiteros.where((t) {
      if ((t.area ?? '').toUpperCase() != _areaFiltro) return false;
      return (t.cargo ?? '').toUpperCase().contains('OPERADOR');
    }).toList();
  }

  void setEspecialidad(EspecialidadOption opcion) {
    if (_especialidad.value != opcion.value) {
      _especialidad = opcion;
      if (_lider != null && (_lider!.area ?? '').toUpperCase() != _areaFiltro) {
        _lider = null;
      }
      _apoyos.removeWhere((t) => (t.area ?? '').toUpperCase() != _areaFiltro);
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

  void setChofer(Gasfitero? t) {
    _chofer = t;
    _errorMsg = null;
    notifyListeners();
  }

  void setOperador(Gasfitero? t) {
    _operador = t;
    _errorMsg = null;
    notifyListeners();
  }

  bool validar() {
    final nombre = nombreController.text.trim();
    if (nombre.isEmpty) {
      _errorMsg = 'El nombre de la cuadrilla es obligatorio';
      notifyListeners();
      return false;
    }
    if (_lider == null) {
      _errorMsg = 'Debe asignar un Gasfitero Principal';
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
        codigoGrupo: nombreController.text.trim(),
        especialidad: _especialidad.value,
        liderId: _lider!.id,
        apoyosIds: _apoyos.map((t) => t.id).toList(),
        choferId: _chofer?.id,
        operadorId: _operador?.id,
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

  @override
  void dispose() {
    nombreController.removeListener(notifyListeners);
    nombreController.dispose();
    super.dispose();
  }
}
