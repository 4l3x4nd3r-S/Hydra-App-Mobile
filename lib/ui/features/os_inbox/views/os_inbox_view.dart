import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../domain/use_cases/start_os_use_case.dart';
import '../../../../domain/use_cases/sync_pending_reports_use_case.dart';
import '../../../core/theme/app_colors.dart';
import '../../theme_view_model.dart';
import '../../auth/views/login_view.dart';
import '../view_models/os_inbox_view_model.dart';
import '../../os_execution/views/os_execution_view.dart';
import '../../os_detail/views/os_detail_view.dart';
import '../widgets/os_inbox_content.dart';
import '../../../core/widgets/profile_modal.dart';

class OsInboxView extends StatelessWidget {
  const OsInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OsInboxViewModel(
        osRepository: context.read<OsRepository>(),
        authRepository: context.read<AuthRepository>(),
        startOsUseCase: context.read<StartOsUseCase>(),
        syncPendingReportsUseCase: context.read<SyncPendingReportsUseCase>(),
      ),
      child: const _OsInboxBody(),
    );
  }
}

class _OsInboxBody extends StatelessWidget {
  const _OsInboxBody();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final themeVm = context.watch<ThemeViewModel>();
    final vm = context.watch<OsInboxViewModel>();

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: c.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.water_drop_rounded,
              color: themeVm.isLight ? c.primary : c.onSurface,
              size: 24,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HYDRA',
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: c.onSurface)),
            Text('Sistema de Gestión Operativa',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: c.onSurfaceVariant)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: c.surface,
              elevation: 4,
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: c.onSurface.withValues(alpha: 0.12),
                child: Text(
                  vm.userName.isNotEmpty ? vm.userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: c.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'profile':
                    ProfileModal.show(
                      context,
                      userName: vm.userName,
                      role: vm.userRole,
                      codigo: vm.userCode,
                      cuadrilla: vm.cuadrillaNombre,
                    );
                    break;
                  case 'theme':
                    themeVm.toggle();
                    break;
                  case 'logout':
                    final authRepo = context.read<AuthRepository>();
                    await authRepo.logout();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                      );
                    }
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.userName.isNotEmpty ? vm.userName : 'Usuario',
                          style: TextStyle(
                              color: c.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      Text(vm.userRole,
                          style: TextStyle(
                              color: c.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_outlined,
                          color: c.onSurfaceVariant, size: 20),
                      const SizedBox(width: 12),
                      Text('Ver Perfil', style: TextStyle(color: c.onSurface)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(
                        themeVm.isLight
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: c.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(themeVm.isLight ? 'Modo Oscuro' : 'Modo Claro',
                          style: TextStyle(color: c.onSurface)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          color: Color(0xFFDC2626), size: 20),
                      SizedBox(width: 12),
                      Text('Cerrar Sesión',
                          style: TextStyle(color: Color(0xFFDC2626))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: OsInboxContent(
        osActivas: vm.osActivas,
        osArchivadas: vm.osArchivadas,
        isLoading: vm.recargandoOs,
        errorMessage: vm.syncErrorMessage,
        pendingSyncCount: vm.pendingSyncCount,
        pendingSyncOrders: vm.pendingSyncOrders,
        isSyncing: vm.sincronizandoManual,
        onSync: vm.syncManual,
        onRefresh: vm.refreshOs,
        isLiderOfOs: vm.canExecuteOs,
        onTapActiva: (os) {
          final isLider = vm.canExecuteOs(os);
          
          if (isLider && os.estadoOrden != 'ASIGNADO') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OsExecutionView(os: os),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OsDetailView(
                os: os,
                showReadOnlyBanner: !isLider,
                isGasfiteroView: true,
                onRegistrarSolucion: isLider
                    ? () async {
                        try {
                          if (os.estadoOrden == 'ASIGNADO') {
                            await vm.startOs(os);
                          }
                        } catch (e) {
                          debugPrint('Error starting OS: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se pudo iniciar la O.S. Inténtelo nuevamente.',
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                          return;
                        }

                        // We fetch the updated OS from the ViewModel so it has the new "EN_PROCESO" status and Start Date
                        final updatedOs = vm.osActivas
                            .firstWhere((o) => o.id == os.id, orElse: () => os);

                        if (context.mounted) {
                          // Navegamos al formulario de ejecución (Solución)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OsExecutionView(os: updatedOs),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ),
          );
        },
        onTapArchivada: (os) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OsDetailView(os: os, isGasfiteroView: true),
            ),
          );
        },
      ),
    );
  }
}
