import 'package:flutter/material.dart';
import '../../../../data/repositories/catastro_repository.dart';
import '../../../../domain/models/datalogger.dart';

class DataloggerListViewModel extends ChangeNotifier {
  final CatastroRepository _catastroRepository;

  List<Datalogger> _dataloggers = [];
  bool _loading = false;

  List<Datalogger> get dataloggers => _dataloggers;
  bool get loading => _loading;

  DataloggerListViewModel({required CatastroRepository catastroRepository})
      : _catastroRepository = catastroRepository {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _dataloggers = await _catastroRepository.getDataloggers();
    _loading = false;
    notifyListeners();
  }
}
