import 'package:flutter/material.dart';
import '../../../../data/repositories/catastro_repository.dart';
import '../../../../domain/models/punto_presion.dart';
import '../../../../domain/models/registro_presion.dart';

class PuntoPresionListViewModel extends ChangeNotifier {
  final CatastroRepository _catastroRepository;

  List<PuntoPresion> _puntos = [];
  bool _loading = false;

  List<PuntoPresion> get puntos => _puntos;
  bool get loading => _loading;

  PuntoPresionListViewModel(
      {required CatastroRepository catastroRepository})
      : _catastroRepository = catastroRepository {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _puntos =
        await _catastroRepository.getPuntosPresion();
    _loading = false;
    notifyListeners();
  }

  Future<RegistroPresion?> getUltimoRegistro(int puntoId) {
    return _catastroRepository
        .getUltimoRegistroPresion(puntoId);
  }
}
