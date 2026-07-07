import '../../domain/models/reclamo.dart';
import '../../data/repositories/supervisor_repository.dart';

class CrearReclamoUseCase {
  final SupervisorRepository _repository;

  CrearReclamoUseCase({required SupervisorRepository repository})
      : _repository = repository;

  Future<Reclamo> call(Reclamo borrador) =>
      _repository.crearReclamo(borrador);
}
