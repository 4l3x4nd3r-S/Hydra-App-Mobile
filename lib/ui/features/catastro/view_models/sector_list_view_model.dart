import 'package:flutter/material.dart';
import '../../../../data/repositories/catastro_repository.dart';
import '../../../../domain/models/sector.dart';

class SectorListViewModel extends ChangeNotifier {
  final CatastroRepository _catastroRepository;

  List<Sector> _sectores = [];
  bool _loading = false;

  List<Sector> get sectores => _sectores;
  bool get loading => _loading;

  SectorListViewModel(
      {required CatastroRepository catastroRepository})
      : _catastroRepository = catastroRepository {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _sectores = await _catastroRepository.getSectores();
    _loading = false;
    notifyListeners();
  }
}
