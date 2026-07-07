import '../../data/repositories/supervisor_repository.dart';
import '../../domain/models/os.dart';

class CreateOsFromReclamoUseCase {
  final SupervisorRepository _supervisorRepository;

  CreateOsFromReclamoUseCase(
      {required SupervisorRepository supervisorRepository})
      : _supervisorRepository = supervisorRepository;

  Future<Os> call({
    required int reclamoId,
    required int cuadrillaId,
  }) async {
    return _supervisorRepository.createOsFromReclamo(
      reclamoId: reclamoId,
      cuadrillaId: cuadrillaId,
    );
  }
}
