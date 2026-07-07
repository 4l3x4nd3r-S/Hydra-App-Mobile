import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import '../../../core/theme/app_colors.dart';
import '../view_models/catastro_gis_view_model.dart';
import 'package:hydra/ui/features/catastro/view_models/catastro_gis_view_model.dart';

class CatastroMapFullscreenView extends StatefulWidget {
  const CatastroMapFullscreenView({super.key});

  @override
  State<CatastroMapFullscreenView> createState() => _CatastroMapFullscreenViewState();
}

class _CatastroMapFullscreenViewState extends State<CatastroMapFullscreenView> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatastroGisViewModel>().loadDynamicData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _flyTo(LatLng coords) {
    _mapController.move(coords, 18.0);
  }

  void _showElementDetails(BuildContext context, CatastroElement element, AppColors c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: c.surface.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: c.border.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                element.nombre,
                style: TextStyle(
                  color: c.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Outfit',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    element.tipo.contains('Válvula') ? Icons.tune_rounded : Icons.speed_rounded,
                    color: c.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    element.tipo,
                    style: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: element.estado.toLowerCase().contains('activo') || element.estado.toLowerCase().contains('operativo')
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFF59E0B),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    element.estado,
                    style: TextStyle(color: c.onSurfaceVariant, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final vm = context.watch<CatastroGisViewModel>();

    // Prepare markers
    final List<Marker> allMarkers = [];
    final List<Marker> sectorLabels = [];
    
    if (vm.showPipesAndSectors) {
      for (var s in vm.sectores) {
        sectorLabels.add(Marker(
          point: s.centroid,
          width: 80,
          height: 30,
          child: IgnorePointer(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: s.color.withValues(alpha: 1.0)),
              ),
              child: Text(
                s.nombre,
                style: TextStyle(
                  color: c.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ));
      }
    }
    
    if (vm.showValves) {
      for (var v in vm.valvulas) {
        if (vm.searchQuery.isEmpty || v.nombre.toLowerCase().contains(vm.searchQuery.toLowerCase())) {
          allMarkers.add(Marker(
            point: v.ubicacion,
            width: 28,
            height: 28,
            child: GestureDetector(
              onTap: () => _showElementDetails(context, v, c),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: const Icon(Icons.build_circle_rounded, color: Colors.white, size: 16),
              ),
            ),
          ));
        }
      }
    }

    if (vm.showPressurePoints) {
      for (var pp in vm.puntosPresion) {
        if (vm.searchQuery.isEmpty || pp.nombre.toLowerCase().contains(vm.searchQuery.toLowerCase())) {
          allMarkers.add(Marker(
            point: pp.ubicacion,
            width: 28,
            height: 28,
            child: GestureDetector(
              onTap: () => _showElementDetails(context, pp, c),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 16),
              ),
            ),
          ));
        }
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(-12.5933, -69.1883), // Puerto Maldonado center roughly
              initialZoom: 14.0,
              maxZoom: 22.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.hydra.app',
              ),
              if (vm.showPipesAndSectors && vm.sectores.isNotEmpty)
                PolygonLayer(
                  polygons: vm.sectores.map((s) => Polygon(
                    points: s.puntos,
                    color: s.color,
                    borderColor: s.color.withValues(alpha: 1.0),
                    borderStrokeWidth: 2,
                  )).toList(),
                ),
              if (sectorLabels.isNotEmpty)
                MarkerLayer(markers: sectorLabels),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 30,
                  size: const Size(30, 30),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(50),
                  maxZoom: 18,
                  markers: allMarkers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: c.primary.withValues(alpha: 0.8),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Glassmorphism Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.15,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Material(
                color: Colors.transparent,
                child: Container(
                decoration: BoxDecoration(
                  color: c.background.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border.all(color: c.border.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: c.onSurfaceVariant.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        vm.setSearchQuery(val);
                        if (val.isNotEmpty) {
                          // Try to fly to the first result
                          final firstMatch = [...vm.valvulas, ...vm.puntosPresion].where(
                            (e) => e.nombre.toLowerCase().contains(val.toLowerCase())
                          ).firstOrNull;
                          if (firstMatch != null) {
                            _flyTo(firstMatch.ubicacion);
                          }
                        }
                      },
                      style: TextStyle(color: c.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Buscar Válvula 45...',
                        hintStyle: TextStyle(color: c.onSurfaceVariant),
                        prefixIcon: Icon(Icons.search_rounded, color: c.primary),
                        filled: true,
                        fillColor: c.surface.withValues(alpha: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Capas del Mapa', style: TextStyle(color: c.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: Text('Sectores', style: TextStyle(color: c.onSurface)),
                      subtitle: Text('${vm.sectores.length} elementos', style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
                      value: vm.showPipesAndSectors,
                      onChanged: vm.togglePipesAndSectors,
                      activeColor: c.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('Válvulas', style: TextStyle(color: c.onSurface)),
                      subtitle: Text('${vm.valvulas.length} elementos', style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
                      value: vm.showValves,
                      onChanged: vm.toggleValves,
                      activeColor: c.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: Text('Puntos de Presión', style: TextStyle(color: c.onSurface)),
                      subtitle: Text('${vm.puntosPresion.length} elementos', style: TextStyle(color: c.onSurfaceVariant, fontSize: 12)),
                      value: vm.showPressurePoints,
                      onChanged: vm.togglePressurePoints,
                      activeColor: c.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              );
            },
          ),
          
          if (vm.isLoading)
            Container(
              color: c.background.withValues(alpha: 0.5),
              child: Center(
                child: CircularProgressIndicator(color: c.primary),
              ),
            ),
        ],
      ),
    );
  }
}
