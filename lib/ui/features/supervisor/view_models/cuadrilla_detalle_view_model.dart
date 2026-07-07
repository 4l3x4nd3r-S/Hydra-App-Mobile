import 'package:flutter/material.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/gasfitero.dart';

class CuadrillaDetalleViewModel extends ChangeNotifier {
  final SupervisorRepository _supervisorRepository;
  final Cuadrilla cuadrilla;
  final List<Gasfitero> gasfiteros;

  Cuadrilla _current;
  Cuadrilla get current => _current;

  List<Gasfitero> _disponibles = [];
  List<Gasfitero> get disponibles => _disponibles;

  List<Gasfitero> get gasfiterosDisponiblesParaRolesPrincipales {
    return _disponibles.where((t) {
      final cargo = (t.cargo ?? '').toUpperCase();
      if (cargo.contains('CHOFER')) return false;
      if (cargo.contains('OPERADOR')) return false;
      return true;
    }).toList();
  }

  List<Gasfitero> get choferesDisponibles {
    return _disponibles.where((t) {
      return (t.cargo ?? '').toUpperCase().contains('CHOFER');
    }).toList();
  }

  List<Gasfitero> get operadoresDisponibles {
    return _disponibles.where((t) {
      return (t.cargo ?? '').toUpperCase().contains('OPERADOR');
    }).toList();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  CuadrillaDetalleViewModel({
    required SupervisorRepository supervisorRepository,
    required this.cuadrilla,
    required this.gasfiteros,
  })  : _supervisorRepository = supervisorRepository,
        _current = cuadrilla {
    Future.microtask(() => refresh(isInitial: true));
  }

  String get _areaFiltro =>
      _current.especialidad == 'Agua' ? 'DISTRIBUCION' : 'MANTENIMIENTO';

  Future<void> refresh({bool isInitial = false}) async {
    if (isInitial) {
      _isLoading = true;
    } else {
      _isActionLoading = true;
    }
    notifyListeners();
    
    _current = await _supervisorRepository.getCuadrilla(cuadrilla.id);
    await _cargarDisponibles();
    
    if (isInitial) {
      _isLoading = false;
    } else {
      _isActionLoading = false;
    }
    notifyListeners();
  }

  Future<void> _cargarDisponibles() async {
    _disponibles = await _supervisorRepository.getgasfiterosDisponibles(area: _areaFiltro);
  }

  Future<void> addPersonal(int usuarioId, String rol) async {
    if (rol == 'LIDER' && _current.lider != null && _current.lider!.id != usuarioId) {
      await _supervisorRepository.removeGasfitero(
        cuadrillaId: cuadrilla.id,
        usuarioId: _current.lider!.id,
      );
    }
    await _supervisorRepository.addGasfitero(
      cuadrillaId: cuadrilla.id,
      usuarioId: usuarioId,
      rol: rol,
    );
    await refresh();
  }

  Future<void> removePersonal(int usuarioId) async {
    await _supervisorRepository.removeGasfitero(
      cuadrillaId: cuadrilla.id,
      usuarioId: usuarioId,
    );
    await refresh();
  }

  Future<bool> deleteCuadrilla() async {
    try {
      await _supervisorRepository.deleteCuadrilla(cuadrilla.id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
