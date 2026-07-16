import '../../data/repositories/os_repository.dart';
import '../models/os_start_result.dart';

class StartOsUseCase {
  final OsRepository _osRepository;

  StartOsUseCase({required OsRepository osRepository})
      : _osRepository = osRepository;

  Future<OsStartResult> call(int ordenId) async {
    return _osRepository.startOrder(ordenId);
  }
}
