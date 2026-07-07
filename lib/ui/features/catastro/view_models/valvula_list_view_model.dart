import 'package:flutter/material.dart';
import '../../../../data/repositories/catastro_repository.dart';
import '../../../../domain/models/valvula.dart';

class ValvulaListViewModel extends ChangeNotifier {
  final CatastroRepository _catastroRepository;

  List<Valvula> _valvulas = [];
  bool _loading = false;

  List<Valvula> get valvulas => _valvulas;
  bool get loading => _loading;

  ValvulaListViewModel(
      {required CatastroRepository catastroRepository})
      : _catastroRepository = catastroRepository {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _valvulas = await _catastroRepository.getValvulas();
    _loading = false;
    notifyListeners();
  }
}
