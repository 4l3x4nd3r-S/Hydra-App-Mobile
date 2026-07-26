import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../data/repositories/os_repository.dart';
import '../../../../data/repositories/supervisor_repository.dart';
import '../../../../data/repositories/catastro_repository.dart';
import '../../../../domain/models/cuadrilla.dart';
import '../../../../domain/models/gasfitero.dart';
import '../../../../domain/models/reclamo.dart';
import '../../../core/theme/app_colors.dart';
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
        supervisorRepository: context.read<SupervisorRepository>(),
        authRepository: context.read<AuthRepository>(),
        catalogRepository: context.read<CatalogRepository>(),
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
  int _selectedSubTabIndex = 0;

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
                    color: themeVm.isLight ? c.primary : c.onSurface,
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
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          color: Colors.redAccent, size: 20),
                      const SizedBox(width: 12),
                      Text('Cerrar Sesión',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w500)),
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
                    ]),
                labelColor: c.onPrimary,
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
            create: (_) => CatastroGisViewModel(
              catastroRepository: context.read<CatastroRepository>(),
            ),
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
                  MaterialPageRoute(builder: (_) => const NuevoReclamoView()),
                );
                if (result == true && mounted) {
                  if (_selectedSubTabIndex != 0) {
                    setState(() => _selectedSubTabIndex = 0);
                  }
                  await vm.cargarTodo(silent: false);
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
        if (vm.errorMessageReclamos != null)
          _buildErrorBanner(c, vm.errorMessageReclamos!),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildSubTabs(c, vm),
            ),
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: vm.loadingReclamos
                ? Center(
                    key: const ValueKey('loading'),
                    child: CircularProgressIndicator(color: c.primary),
                  )
                : IndexedStack(
                    key: const ValueKey('content'),
                    index: _selectedSubTabIndex,
                    children: [
                      _buildListaPorEstado(c, vm.reclamosPendientes,
                          'No hay reclamos pendientes', Icons.schedule_outlined),
                      _buildListaPorEstado(
                          c,
                          vm.reclamosAsignados,
                          'No hay reclamos asignados',
                          Icons.assignment_turned_in_outlined),
                      _buildListaPorEstado(c, vm.reclamosCerrados,
                          'No hay reclamos cerrados', Icons.check_circle_outline),
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

  Widget _buildSubTabs(AppColors c, SupervisorViewModel vm) {
    final tabs = [
      ('PENDIENTES', vm.reclamosPendientes.length, c.primary),
      ('ASIGNADOS', vm.reclamosAsignados.length, const Color(0xFFF59E0B)),
      ('CERRADOS', vm.reclamosCerrados.length, const Color(0xFF22C55E)),
    ];

    return Row(
      children: tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final (label, count, color) = entry.value;
        final isSelected = _selectedSubTabIndex == i;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedSubTabIndex = i),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? color : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                        color: isSelected ? color : c.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListaPorEstado(
    AppColors c,
    List<Reclamo> reclamos,
    String emptyMsg,
    IconData emptyIcon,
  ) {
    final vm = context.read<SupervisorViewModel>();
    if (reclamos.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          final vm = context.read<SupervisorViewModel>();
          await vm.cargarTodo();
        },
        child: ListView(
          children: [
            SizedBox(
              height: 220,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(emptyIcon,
                        size: 48,
                        color: c.onSurfaceVariant.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    Text(
                      emptyMsg,
                      style: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final vm = context.read<SupervisorViewModel>();
        await vm.cargarTodo();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: reclamos.length,
        itemBuilder: (context, index) {
          final r = reclamos[index];
          return ReclamoListTile(
            data: ReclamoTileData.fromReclamo(
              r,
              tipoProblemaDescripcion:
                  vm.descripcionTipoProblema(r.tipoProblema),
              onTap: () async {
                final vm = context.read<SupervisorViewModel>();
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
        },
      ),
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

    final agua =
        vm.cuadrillas.where((cu) => (cu.especialidad ?? '') == 'Agua').toList();
    final alcantarillado = vm.cuadrillas
        .where((cu) => (cu.especialidad ?? '') == 'Alcantarillado')
        .toList();
    final sinClasificar = vm.cuadrillas
        .where((cu) =>
            (cu.especialidad ?? '') != 'Agua' &&
            (cu.especialidad ?? '') != 'Alcantarillado')
        .toList();

    Widget content;
    if (vm.loadingCuadrillas) {
      content = Center(
          key: const ValueKey('loading'),
          child: CircularProgressIndicator(color: c.primary));
    } else if (vm.cuadrillas.isEmpty) {
      content = RefreshIndicator(
        key: const ValueKey('empty'),
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
    } else {
      content = RefreshIndicator(
        key: const ValueKey('list'),
        onRefresh: () async => await vm.cargarTodo(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _buildHeader(c, vm),
            const SizedBox(height: 16),
            if (agua.isNotEmpty) ...[
              _buildSectionLabel('Agua', agua.length, c),
              const SizedBox(height: 8),
              ...agua.map((cu) => _buildCuadrillaCard(cu)),
              const SizedBox(height: 20),
            ],
            if (alcantarillado.isNotEmpty) ...[
              _buildSectionLabel('Alcantarillado', alcantarillado.length, c),
              const SizedBox(height: 8),
              ...alcantarillado.map((cu) => _buildCuadrillaCard(cu)),
              const SizedBox(height: 20),
            ],
            if (sinClasificar.isNotEmpty) ...[
              _buildSectionLabel('Sin clasificar', sinClasificar.length, c),
              const SizedBox(height: 8),
              ...sinClasificar.map((cu) => _buildCuadrillaCard(cu)),
            ],
            if (agua.isEmpty && alcantarillado.isEmpty && sinClasificar.isEmpty) ...[
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: content,
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

  Widget _buildSectionLabel(String text, int cantidad, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: c.primary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$cantidad',
              style: TextStyle(
                color: c.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuadrillaCard(Cuadrilla cu) {
    final c = Theme.of(context).extension<AppColors>()!;
    final identificador = cu.codigoGrupo?.trim().isNotEmpty == true
        ? cu.codigoGrupo!.trim()
        : 'Cuadrilla sin identificar';
    final nombreLider = cu.lider?.nombre?.trim().isNotEmpty == true
        ? cu.lider!.nombre!.trim()
        : 'Sin líder asignado';
    final palabras = nombreLider
        .split(RegExp(r'\s+'))
        .where((palabra) => palabra.isNotEmpty)
        .take(2);
    final iniciales =
        palabras.map((palabra) => palabra[0]).join().toUpperCase();

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      identificador,
                      style: TextStyle(
                        color: c.onSurface,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: c.background.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: c.primary.withValues(alpha: 0.14),
                      child: Text(
                        iniciales.isEmpty ? '—' : iniciales,
                        style: TextStyle(
                          color: c.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cu.lider?.funcionVisible ?? '',
                            style: TextStyle(
                              color: c.onSurfaceVariant,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.7,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nombreLider,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: c.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.groups_outlined,
                      size: 16, color: c.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    '${cu.cantidadIntegrantes} integrantes',
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

    return _buildPersonalList(
      context,
      vm.personalMantenimientoOrdenado,
      c,
    );
  }

  Widget _buildPersonalList(
      BuildContext context, List<Gasfitero> gasfiteros, AppColors c) {
    if (gasfiteros.isEmpty) {
      return Center(
        child: Text(
          'No hay personal asignado',
          style:
              TextStyle(color: c.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: gasfiteros.length,
      itemBuilder: (context, index) {
        return _buildPersonalCard(context, c, gasfiteros[index]);
      },
    );
  }

  Widget _buildPersonalCard(BuildContext context, AppColors c, Gasfitero t) {
    final cargoTexto = t.funcionVisible ?? '';
    final esPrincipal = t.esPrincipal;

    String iniciales = '';
    if (t.nombre != null && t.nombre!.isNotEmpty) {
      final partes = t.nombre!.trim().split(RegExp(r'\s+'));
      if (partes.length >= 2) {
        iniciales = '${partes[0][0]}${partes[1][0]}'.toUpperCase();
      } else if (partes.isNotEmpty) {
        iniciales = partes[0][0].toUpperCase();
      }
    }

    final nombreCuadrilla = t.codigoCuadrilla;
    final codigoCuadrilla = t.codigoCuadrilla;

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
            dni: t.dni,
            celular: t.celular,
            area: t.areaVisible,
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
        subtitle: Row(
          children: [
            if (esPrincipal) ...[
              Icon(Icons.star_rounded, size: 15, color: c.primary),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                cargoTexto,
                style: TextStyle(
                  color: esPrincipal ? c.primary : c.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: esPrincipal ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
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
