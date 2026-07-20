import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'data/services/sync_queue_storage_service.dart';
import 'data/services/session_storage_service.dart';
import 'data/services/theme_storage_service.dart';
import 'data/services/api_client.dart';
import 'data/services/api_endpoints.dart';
import 'data/services/app_environment.dart';
import 'data/services/auth_api_service.dart';
import 'data/services/os_api_service.dart';
import 'data/services/supervisor_api_service.dart';
import 'data/services/catastro_api_service.dart';
import 'data/services/catalog_api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/os_repository.dart';
import 'data/repositories/supervisor_repository.dart';
import 'data/repositories/catastro_repository.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/repositories/theme_repository.dart';
import 'domain/use_cases/login_use_case.dart';
import 'domain/use_cases/validate_session_use_case.dart';
import 'domain/use_cases/save_os_report_use_case.dart';
import 'domain/use_cases/start_os_use_case.dart';
import 'domain/use_cases/sync_pending_reports_use_case.dart';
import 'domain/use_cases/create_os_from_reclamo_use_case.dart';
import 'domain/use_cases/crear_reclamo_use_case.dart';
import 'ui/core/services/session_event_bus.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.validate();

  final syncQueueStorage = SyncQueueStorageService();
  final sessionStorage = SessionStorageService(storage: syncQueueStorage);
  final themeStorage = ThemeStorageService(storage: syncQueueStorage);
  final sessionEventBus = SessionEventBus();
  final apiClient = ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
    sessionStorage: sessionStorage,
    sessionEventBus: sessionEventBus,
  );

  final authApiService = AuthApiService(apiClient: apiClient);
  final osApiService = OsApiService(apiClient: apiClient);
  final supervisorApiService = SupervisorApiService(apiClient: apiClient);
  final catastroApiService = CatastroApiService(apiClient: apiClient);
  final catalogApiService = CatalogApiService(apiClient: apiClient);

  final authRepository = AuthRepository(
    authApiService: authApiService,
    sessionStorage: sessionStorage,
  );
  final osRepository = OsRepository(
    osApiService: osApiService,
    syncQueueStorage: syncQueueStorage,
  );
  final supervisorRepository = SupervisorRepository(
    apiService: supervisorApiService,
  );
  final catastroRepository = CatastroRepository(
    apiService: catastroApiService,
  );
  final catalogRepository = CatalogRepository(apiService: catalogApiService);
  final themeRepository = ThemeRepository(themeStorage: themeStorage);

  final loginUseCase = LoginUseCase(authRepository: authRepository);
  final validateSessionUseCase =
      ValidateSessionUseCase(authRepository: authRepository);
  final saveOsReportUseCase = SaveOsReportUseCase(osRepository: osRepository);
  final startOsUseCase = StartOsUseCase(osRepository: osRepository);
  final syncPendingReportsUseCase =
      SyncPendingReportsUseCase(osRepository: osRepository);
  final createOsFromReclamoUseCase =
      CreateOsFromReclamoUseCase(supervisorRepository: supervisorRepository);
  final crearReclamoUseCase =
      CrearReclamoUseCase(repository: supervisorRepository);

  osRepository.startAutoSync();

  runApp(
    HydraApp(
      syncQueueStorage: syncQueueStorage,
      sessionStorage: sessionStorage,
      apiClient: apiClient,
      authRepository: authRepository,
      osRepository: osRepository,
      supervisorRepository: supervisorRepository,
      catastroRepository: catastroRepository,
      catalogRepository: catalogRepository,
      themeRepository: themeRepository,
      loginUseCase: loginUseCase,
      validateSessionUseCase: validateSessionUseCase,
      saveOsReportUseCase: saveOsReportUseCase,
      startOsUseCase: startOsUseCase,
      syncPendingReportsUseCase: syncPendingReportsUseCase,
      createOsFromReclamoUseCase: createOsFromReclamoUseCase,
      sessionEventBus: sessionEventBus,
      crearReclamoUseCase: crearReclamoUseCase,
    ),
  );

  _autoSyncAlArrancar(osRepository);
}

void _autoSyncAlArrancar(OsRepository osRepository) async {
  try {
    await Future.delayed(const Duration(seconds: 2));
    final results = await Connectivity().checkConnectivity();
    if (results.any((r) => r != ConnectivityResult.none)) {
      osRepository.triggerSync();
    }
  } catch (_) {}
}
