import '../../data/repositories/os_repository.dart';

class StartOsUseCase {
  final OsRepository _osRepository;

  StartOsUseCase({required OsRepository osRepository})
      : _osRepository = osRepository;

  Future<void> call(int ordenId) async {
    await _osRepository.startOrder(ordenId);
  }
}
