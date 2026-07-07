import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/core/theme/app_theme.dart';
import 'ui/core/services/session_event_bus.dart';
import 'ui/features/theme_view_model.dart';
import 'ui/features/auth/views/session_gate_view.dart';
import 'data/services/sync_queue_storage_service.dart';
import 'data/services/session_storage_service.dart';
import 'data/services/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/os_repository.dart';
import 'data/repositories/supervisor_repository.dart';
import 'data/repositories/catastro_repository.dart';
import 'data/repositories/theme_repository.dart';
import 'domain/use_cases/login_use_case.dart';
import 'domain/use_cases/validate_session_use_case.dart';
import 'domain/use_cases/save_os_report_use_case.dart';
import 'domain/use_cases/start_os_use_case.dart';
import 'domain/use_cases/sync_pending_reports_use_case.dart';
import 'domain/use_cases/create_os_from_reclamo_use_case.dart';
import 'domain/use_cases/crear_reclamo_use_case.dart';

class HydraApp extends StatefulWidget {
  final SyncQueueStorageService syncQueueStorage;
  final SessionStorageService sessionStorage;
  final ApiClient apiClient;
  final AuthRepository authRepository;
  final OsRepository osRepository;
  final SupervisorRepository supervisorRepository;
  final CatastroRepository catastroRepository;
  final ThemeRepository themeRepository;
  final LoginUseCase loginUseCase;
  final ValidateSessionUseCase validateSessionUseCase;
  final SaveOsReportUseCase saveOsReportUseCase;
  final StartOsUseCase startOsUseCase;
  final SyncPendingReportsUseCase syncPendingReportsUseCase;
  final CreateOsFromReclamoUseCase createOsFromReclamoUseCase;
  final CrearReclamoUseCase crearReclamoUseCase;
  final SessionEventBus sessionEventBus;

  const HydraApp({
    super.key,
    required this.syncQueueStorage,
    required this.sessionStorage,
    required this.apiClient,
    required this.authRepository,
    required this.osRepository,
    required this.supervisorRepository,
    required this.catastroRepository,
    required this.themeRepository,
    required this.loginUseCase,
    required this.validateSessionUseCase,
    required this.saveOsReportUseCase,
    required this.startOsUseCase,
    required this.syncPendingReportsUseCase,
    required this.createOsFromReclamoUseCase,
    required this.crearReclamoUseCase,
    required this.sessionEventBus,
  });

  @override
  State<HydraApp> createState() => _HydraAppState();
}

class _HydraAppState extends State<HydraApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<void>? _sessionSub;

  @override
  void initState() {
    super.initState();
    _sessionSub = widget.sessionEventBus.onSessionExpired.listen((_) {
      _onSessionExpired();
    });
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    super.dispose();
  }

  void _onSessionExpired() {
    if (mounted) {
      _navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.syncQueueStorage),
        Provider.value(value: widget.sessionStorage),
        Provider.value(value: widget.apiClient),
        Provider.value(value: widget.authRepository),
        Provider.value(value: widget.osRepository),
        Provider.value(value: widget.supervisorRepository),
        Provider.value(value: widget.catastroRepository),
        Provider.value(value: widget.themeRepository),
        Provider.value(value: widget.loginUseCase),
        Provider.value(value: widget.validateSessionUseCase),
        Provider.value(value: widget.saveOsReportUseCase),
        Provider.value(value: widget.startOsUseCase),
        Provider.value(value: widget.syncPendingReportsUseCase),
        Provider.value(value: widget.createOsFromReclamoUseCase),
        Provider.value(value: widget.crearReclamoUseCase),
        Provider.value(value: widget.sessionEventBus),
        ChangeNotifierProvider(
          create: (_) =>
              ThemeViewModel(themeRepository: widget.themeRepository)..load(),
        ),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) => MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'HYDRA - EMAPAT S.A.',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeVm.mode,
          home: const SessionGateView(),
        ),
      ),
    );
  }
}
