import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
    return _disponibles.where((t) => t.puedeSerGasfitero).toList();
  }

  List<Gasfitero> get choferesDisponibles {
    return _disponibles.where((t) => t.puedeSerChofer).toList();
  }

  List<Gasfitero> get candidatosApoyo {
    return _personalElegible(
      [..._current.apoyos, ..._disponibles],
    ).where((persona) {
      return persona.id != _current.lider?.id &&
          persona.id != _current.chofer?.id;
    }).toList();
  }

  List<Gasfitero> get candidatosLider {
    return _personalElegible([
      if (_current.lider != null) _current.lider!,
      ..._current.apoyos,
      ..._disponibles,
    ]);
  }

  List<Gasfitero> _personalElegible(List<Gasfitero> personas) {
    final unicos = <int, Gasfitero>{};
    for (final persona in personas) {
      if (!persona.puedeSerGasfitero) continue;
      unicos[persona.id] = persona;
    }
    final resultado = unicos.values.toList();
    resultado.sort(
      (a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''),
    );
    return resultado;
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _actionError;
  String? get actionError => _actionError;

  CuadrillaDetalleViewModel({
    required SupervisorRepository supervisorRepository,
    required this.cuadrilla,
    required this.gasfiteros,
  })  : _supervisorRepository = supervisorRepository,
        _current = cuadrilla {
    Future.microtask(() => refresh(isInitial: true));
  }

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
    _disponibles = await _supervisorRepository.getgasfiterosDisponibles();
  }

  Future<void> addPersonal(int usuarioId, String rol) async {
    if (rol == 'LIDER') {
      await changeLeader(usuarioId);
      return;
    }
    if (rol == 'APOYO') {
      await updateSupports({
        ..._current.apoyos.map((persona) => persona.id),
        usuarioId,
      });
      return;
    }
    await _supervisorRepository.addGasfitero(
      cuadrillaId: cuadrilla.id,
      usuarioId: usuarioId,
      rol: rol,
    );
    await refresh();
  }

  Future<void> removePersonal(int usuarioId) async {
    if (_current.apoyos.any((persona) => persona.id == usuarioId)) {
      await updateSupports(
        _current.apoyos
            .where((persona) => persona.id != usuarioId)
            .map((persona) => persona.id)
            .toSet(),
      );
      return;
    }
    await _supervisorRepository.removeGasfitero(
      cuadrillaId: cuadrilla.id,
      usuarioId: usuarioId,
    );
    await refresh();
  }

  Future<bool> updateSupports(Set<int> selectedIds) async {
    final lider = _current.lider;
    if (lider == null) {
      _actionError = 'La cuadrilla debe tener un gasfitero principal.';
      notifyListeners();
      return false;
    }
    return _replacePersonal(
      liderId: lider.id,
      apoyosIds: selectedIds.toList()..sort(),
    );
  }

  Future<bool> changeLeader(int newLeaderId) async {
    final currentLeader = _current.lider;
    if (currentLeader?.id == newLeaderId) return true;

    final supportIds = _current.apoyos
        .where((persona) => persona.id != newLeaderId)
        .map((persona) => persona.id)
        .toSet();
    if (currentLeader != null) {
      supportIds.add(currentLeader.id);
    }

    return _replacePersonal(
      liderId: newLeaderId,
      apoyosIds: supportIds.toList()..sort(),
    );
  }

  Future<bool> _replacePersonal({
    required int liderId,
    required List<int> apoyosIds,
  }) async {
    final totalIntegrantes = {
      liderId,
      ...apoyosIds,
      if (_current.chofer != null) _current.chofer!.id,
    }.length;
    if (totalIntegrantes < 2) {
      _actionError = 'La cuadrilla debe conservar al menos 2 integrantes.';
      notifyListeners();
      return false;
    }

    _isActionLoading = true;
    _actionError = null;
    notifyListeners();
    try {
      _current = await _supervisorRepository.updateCuadrillaPersonal(
        cuadrillaId: cuadrilla.id,
        liderId: liderId,
        apoyosIds: apoyosIds,
        choferId: _current.chofer?.id,
      );
      await _cargarDisponibles();
      return true;
    } on DioException catch (error) {
      final detail = error.response?.data is Map
          ? (error.response?.data as Map)['detail']?.toString()
          : null;
      _actionError = detail ?? 'No se pudo actualizar el personal.';
      return false;
    } catch (_) {
      _actionError = 'No se pudo actualizar el personal.';
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
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
