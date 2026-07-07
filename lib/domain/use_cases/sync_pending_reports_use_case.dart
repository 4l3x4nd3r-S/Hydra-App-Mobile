import '../../data/repositories/os_repository.dart';

class SyncPendingReportsUseCase {
  final OsRepository _osRepository;

  SyncPendingReportsUseCase({required OsRepository osRepository})
      : _osRepository = osRepository;

  Future<void> call() async {
    await _osRepository.triggerSync();
  }
}
