import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/gasfitero.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/profile_modal.dart';
import '../../theme_view_model.dart';
import '../../auth/views/login_view.dart';
import '../view_models/supervisor_view_model.dart';
import '../../catastro/views/catastro_map_fullscreen_view.dart';
import '../../catastro/view_models/catastro_gis_view_model.dart';
import '../view_models/supervisor_os_view_model.dart';
import '../widgets/nueva_cuadrilla_modal.dart';
import '../widgets/reclamo_tile_data.dart';
import '../widgets/reclamo_list_tile.dart';
import '../../../core/widgets/section_card.dart';
import '../../os_inbox/widgets/os_inbox_content.dart';
import '../../os_detail/views/os_detail_view.dart';
import 'reclamo_detalle_view.dart';
import 'cuadrilla_detalle_view.dart';

import 'nuevo_reclamo_view.dart';

class SupervisorView extends StatelessWidget {
  const SupervisorView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SupervisorViewModel(
        supervisorRepository:
            context.read<SupervisorRepository>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _SupervisorBody(),
    );
  }
}

class _SupervisorBody extends StatefulWidget {
  const _SupervisorBody();

  @override
  State<_SupervisorBody> createState() => _SupervisorBodyState();
}

class _SupervisorBodyState extends State<_SupervisorBody>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final themeVm = context.watch<ThemeViewModel>();
    final vm = context.watch<SupervisorViewModel>();

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: c.surface,
              elevation: 4,
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: c.primary.withValues(alpha: 0.1),
                child: Text(
                  vm.userName.isNotEmpty ? vm.userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: c.primary,
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
                      dni: vm.userCode,
                    );
                    break;
                  case 'theme':
                    themeVm.toggle();
                    break;
                  case 'logout':
                    final authRepo = context.read<AuthRepository>();
                    await authRepo.logout();
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
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
                          style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(vm.userRole, style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_outlined, color: c.onSurfaceVariant, size: 20),
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
                        themeVm.isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                        color: c.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(themeVm.isLight ? 'Modo Oscuro' : 'Modo Claro', style: TextStyle(color: c.onSurface)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                      const SizedBox(width: 12),
                      Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: c.border.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: c.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                labelColor: Colors.white,
                unselectedLabelColor: c.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Reclamos'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.engineering_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('O.S.'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.groups_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Cuadrillas'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.badge_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Personal'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Catastro'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabReclamos(),
          _buildTabHistorial(),
          _buildTabCuadrillas(),
          _buildTabPersonal(),
          ChangeNotifierProvider(
            create: (_) => CatastroGisViewModel(),
            child: const CatastroMapFullscreenView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabReclamos() {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<SupervisorViewModel>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                backgroundColor: c.primary.withValues(alpha: 0.12),
                foregroundColor: c.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NuevoReclamoView()),
                );
                if (result == true && mounted) {
                  vm.cargarTodo(silent: false);
                }
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('NUEVOS RECLAMOS',
                  style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
          ),
        ),
        Expanded(
          child: vm.loadingReclamos
              ? Center(
                  child: CircularProgressIndicator(color: c.primary))
              : RefreshIndicator(
                  onRefresh: () async => await vm.cargarTodo(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      if (vm.errorMessageReclamos != null)
                        _buildErrorBanner(c, vm.errorMessageReclamos!),
                      _buildSeccionReclamos(
                        c,
                        vm,
                        'PENDIENTES',
                        vm.reclamosPendientes,
                        'No hay reclamos pendientes',
                        Icons.report_problem_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildSeccionReclamos(
                        c,
                        vm,
                        'ASIGNADOS',
                        vm.reclamosAsignados,
                        'No hay reclamos asignados',
                        Icons.assignment_turned_in_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildSeccionReclamos(
                        c,
                        vm,
                        'CERRADOS',
                        vm.reclamosCerrados,
                        'No hay reclamos cerrados',
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(AppColors c, String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionReclamos(
    AppColors c,
    SupervisorViewModel vm,
    String titulo,
    List<Reclamo> reclamos,
    String emptyMsg,
    IconData icon,
  ) {
    final tiles = reclamos.map((r) {
      return ReclamoListTile(
        data: ReclamoTileData.fromReclamo(
          r,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReclamoDetalleView(
                  reclamo: r,
                  cuadrillas: vm.cuadrillas,
                ),
              ),
            );
            vm.cargarTodo(silent: true);
          },
        ),
        c: c,
      );
    }).toList();

    return SectionCard(
      title: titulo,
      count: reclamos.length,
      emptyMessage: emptyMsg,
      c: c,
      tiles: tiles,
    );
  }

  Widget _buildTabHistorial() {
    return ChangeNotifierProvider(
      create: (_) => SupervisorOsViewModel(
        osRepository: context.read<OsRepository>(),
        supervisorRepository: context.read<SupervisorRepository>(),
      ),
      child: Consumer<SupervisorOsViewModel>(
          builder: (context, vm, _) => OsInboxContent(
            osActivas: vm.osActivas,
            osArchivadas: vm.osArchivadas,
            isLoading: vm.isLoading,
            errorMessage: vm.errorMessage,
            onRefresh: () async => await vm.cargarTodo(),
          onTapActiva: (os) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OsDetailView(os: os),
              ),
            );
          },
          onTapArchivada: (os) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OsDetailView(os: os),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabCuadrillas() {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<SupervisorViewModel>();

    final agua = vm.cuadrillas
        .where((cu) => (cu.especialidad ?? '') == 'Agua')
        .toList();
    final desague = vm.cuadrillas
        .where((cu) => (cu.especialidad ?? '') == 'Desagüe')
        .toList();
    final sinClasificar = vm.cuadrillas
        .where((cu) =>
            (cu.especialidad ?? '') != 'Agua' &&
            (cu.especialidad ?? '') != 'Desagüe')
        .toList();

    if (vm.loadingCuadrillas) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }

    if (vm.cuadrillas.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => await vm.cargarTodo(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildHeader(c, vm),
            const SizedBox(height: 24),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.groups_outlined,
                        color: c.onSurfaceVariant, size: 48),
                    const SizedBox(height: 12),
                    Text('No hay cuadrillas registradas',
                        style: TextStyle(color: c.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await vm.cargarTodo(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildHeader(c, vm),
          const SizedBox(height: 16),
          if (agua.isNotEmpty) ...[
            _buildSectionLabel('Área de Distribución', c),
            const SizedBox(height: 8),
            ...agua.map((cu) => _buildCuadrillaCard(cu)),
            const SizedBox(height: 20),
          ],
          if (desague.isNotEmpty) ...[
            _buildSectionLabel('Área de Mantenimiento', c),
            const SizedBox(height: 8),
            ...desague.map((cu) => _buildCuadrillaCard(cu)),
            const SizedBox(height: 20),
          ],
          if (sinClasificar.isNotEmpty) ...[
            _buildSectionLabel('Sin clasificar', c),
            const SizedBox(height: 8),
            ...sinClasificar.map((cu) => _buildCuadrillaCard(cu)),
          ],
          if (agua.isEmpty && desague.isEmpty) ...[
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Aún no hay cuadrillas con especialidad asignada',
                style: TextStyle(color: c.onSurfaceVariant, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(AppColors c, SupervisorViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              backgroundColor: c.primary.withValues(alpha: 0.12),
              foregroundColor: c.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final creada = await showNuevaCuadrillaModal(context);
              if (creada == true) {
                await vm.cargarTodo(silent: false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cuadrilla creada correctamente'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'NUEVA CUADRILLA',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.6,
              ),
            ),
          ),
    );
  }

  Widget _buildSectionLabel(String text, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: c.primary,
        ),
      ),
    );
  }

  Widget _buildCuadrillaCard(Cuadrilla cu) {
    final c = Theme.of(context).extension<AppColors>()!;
    
    // Titulo
    final nombreCompleto = cu.lider?.nombre ?? 'Sin líder';
    final partesNombre = nombreCompleto.split(' ').where((s) => s.isNotEmpty).toList();
    
    String nombreFormateado = nombreCompleto;
    if (partesNombre.length > 1) {
      final inicial = partesNombre[0][0].toUpperCase();
      final apellido = partesNombre[1];
      nombreFormateado = '$inicial. $apellido';
    } else if (partesNombre.isNotEmpty) {
      nombreFormateado = partesNombre[0];
    }

    final codigoLimpio = (cu.codigoGrupo ?? cu.id.toString()).replaceAll('#', '').trim();
    final titulo = nombreCompleto != 'Sin líder' ? '$codigoLimpio - $nombreFormateado' : codigoLimpio;

    // Integrantes
    final personal = (cu.lider != null ? 1 : 0) + cu.apoyos.length + (cu.chofer != null ? 1 : 0) + (cu.operador != null ? 1 : 0);

    return Card(
      color: c.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: c.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          final vm = context.read<SupervisorViewModel>();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CuadrillaDetalleView(
                cuadrilla: cu,
                gasfiteros: vm.gasfiteros,
              ),
            ),
          );
          vm.cargarTodo(silent: true);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      titulo,
                      style: TextStyle(
                        color: c.onSurface,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: c.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 12),
              
              // Carga Laboral (Placeholder till API supports it)
              Row(
                children: [
                  Icon(Icons.assignment_outlined, size: 16, color: c.primary),
                  const SizedBox(width: 8),
                  Text(
                    'O.S. Pendientes: 0', // TODO: Fetch from backend
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Personal operativo
              Row(
                children: [
                  Icon(Icons.groups_outlined, size: 16, color: c.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    'Personal operativo: $personal',
                    style: TextStyle(
                      color: c.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabPersonal() {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<SupervisorViewModel>();

    if (vm.loadinggasfiteros) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (vm.gasfiteros.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded,
                color: c.onSurfaceVariant, size: 48),
            const SizedBox(height: 12),
            Text('No hay personal registrado',
                style: TextStyle(color: c.onSurfaceVariant)),
          ],
        ),
      );
    }

    int getCargoPriority(String? cargo) {
      if (cargo == null) return 3;
      final c = cargo.toUpperCase();
      if (c.contains('OPERADOR')) return 0;
      if (c.contains('CHOFER')) return 1;
      return 2;
    }

    final distribucion = vm.gasfiteros
        .where((t) => t.area == 'DISTRIBUCION')
        .toList()
      ..sort((a, b) {
        final pA = getCargoPriority(a.cargo);
        final pB = getCargoPriority(b.cargo);
        if (pA != pB) return pA.compareTo(pB);
        return (a.nombre ?? '').compareTo(b.nombre ?? '');
      });

    final mantenimiento = vm.gasfiteros
        .where((t) => t.area == 'MANTENIMIENTO')
        .toList()
      ..sort((a, b) {
        final pA = getCargoPriority(a.cargo);
        final pB = getCargoPriority(b.cargo);
        if (pA != pB) return pA.compareTo(pB);
        return (a.nombre ?? '').compareTo(b.nombre ?? '');
      });

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.border),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: c.primary,
                unselectedLabelColor: c.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Distribución'),
                  Tab(text: 'Mantenimiento'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPersonalList(context, distribucion, c, vm),
                _buildPersonalList(context, mantenimiento, c, vm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalList(BuildContext context, List<Gasfitero> gasfiteros, AppColors c, SupervisorViewModel vm) {
    if (gasfiteros.isEmpty) {
      return Center(
        child: Text(
          'No hay personal asignado',
          style: TextStyle(color: c.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      );
    }
    
    final sortedList = List<Gasfitero>.from(gasfiteros);
    sortedList.sort((a, b) {
      final aAsignado = vm.cuadrillas.any((cu) => 
        cu.lider?.id == a.id || cu.chofer?.id == a.id || cu.operador?.id == a.id || cu.apoyos.any((p) => p.id == a.id));
      final bAsignado = vm.cuadrillas.any((cu) => 
        cu.lider?.id == b.id || cu.chofer?.id == b.id || cu.operador?.id == b.id || cu.apoyos.any((p) => p.id == b.id));
      
      int getPriority(Gasfitero p, bool isAssigned) {
        if (isAssigned) return 0;
        final cargo = (p.cargo ?? '').toUpperCase();
        if (cargo.contains('OPERADOR') || cargo.contains('CHOFER')) return 1;
        return 2;
      }

      final pA = getPriority(a, aAsignado);
      final pB = getPriority(b, bAsignado);

      if (pA != pB) {
        return pA.compareTo(pB);
      }
      return (a.nombre ?? '').compareTo(b.nombre ?? '');
    });

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        return _buildPersonalCard(context, c, sortedList[index], vm);
      },
    );
  }

  Widget _buildPersonalCard(BuildContext context, AppColors c, Gasfitero t, SupervisorViewModel vm) {
    String cargoTexto = t.cargo != null
        ? t.cargo!
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
            .join(' ')
        : 'Sin cargo asignado';

    // Validación solicitada: Si es "Gasfitero Principal", verificar si realmente es líder de alguna cuadrilla
    if (t.cargo == 'GASFITERO_PRINCIPAL') {
      final esLider = vm.cuadrillas.any((cuadrilla) => cuadrilla.lider?.id == t.id);
      if (!esLider) {
        cargoTexto = 'Gasfitero';
      }
    }

    String iniciales = '';
    if (t.nombre != null && t.nombre!.isNotEmpty) {
      final partes = t.nombre!.trim().split(RegExp(r'\s+'));
      if (partes.length >= 2) {
        iniciales = '${partes[0][0]}${partes[1][0]}'.toUpperCase();
      } else if (partes.isNotEmpty) {
        iniciales = partes[0][0].toUpperCase();
      }
    }

    String? nombreCuadrilla;
    String? codigoCuadrilla;
    final cuadrillaAsignada = vm.cuadrillas.where((cu) {
      if (cu.lider?.id == t.id) return true;
      if (cu.chofer?.id == t.id) return true;
      if (cu.operador?.id == t.id) return true;
      if (cu.apoyos.any((a) => a.id == t.id)) return true;
      return false;
    }).firstOrNull;
    
    if (cuadrillaAsignada != null) {
      nombreCuadrilla = 'Cuadrilla ${cuadrillaAsignada.codigoGrupo ?? cuadrillaAsignada.id}';
      codigoCuadrilla = cuadrillaAsignada.codigoGrupo ?? cuadrillaAsignada.id.toString();
    }

    return Card(
      color: c.surface,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c.border.withValues(alpha: 0.6)),
      ),
      child: ListTile(
        onTap: () {
          ProfileModal.show(
            context,
            userName: t.nombre ?? 'Sin Nombre',
            role: cargoTexto,
            dni: t.codigoEmpleado,
            cuadrilla: nombreCuadrilla,
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: c.primary.withValues(alpha: 0.12),
          child: Text(
            iniciales,
            style: TextStyle(
              color: c.primary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          t.nombre ?? 'Sin Nombre',
          style: TextStyle(
            color: c.onSurface,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          cargoTexto,
          style: TextStyle(
            color: c.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: codigoCuadrilla != null 
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: c.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                codigoCuadrilla.toUpperCase().replaceAll('#', ''),
                style: TextStyle(
                  color: c.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  letterSpacing: 0.5,
                ),
              ),
            )
          : null,
      ),
    );
  }
}
