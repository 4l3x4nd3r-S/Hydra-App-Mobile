import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/services/app_environment.dart';
import '../../../core/theme/app_colors.dart';

class ExecutionLocationMap extends StatefulWidget {
  const ExecutionLocationMap({
    super.key,
    required this.location,
    this.initialCenter,
    this.initialZoom = 16,
    this.fullScreen = false,
    this.tileProvider,
  });

  final LatLng location;
  final LatLng? initialCenter;
  final double initialZoom;
  final bool fullScreen;
  final TileProvider? tileProvider;

  @override
  State<ExecutionLocationMap> createState() => _ExecutionLocationMapState();
}

class _ExecutionLocationMapState extends State<ExecutionLocationMap> {
  final _controller = MapController();
  bool _ready = false;

  @override
  void didUpdateWidget(ExecutionLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_ready && oldWidget.location != widget.location) {
      _controller.move(widget.location, _controller.camera.zoom);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _expand() {
    final camera = _controller.camera;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Ubicación del trabajo')),
        body: SafeArea(
          top: false,
          child: ExecutionLocationMap(
            location: widget.location,
            initialCenter: camera.center,
            initialZoom: camera.zoom,
            fullScreen: true,
            tileProvider: widget.tileProvider,
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<AppColors>()!;
    final tileUrl = AppEnvironment.locationMapTileUrl;
    final map = FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: widget.initialCenter ?? widget.location,
        initialZoom: widget.initialZoom,
        minZoom: 3,
        maxZoom: 20,
        backgroundColor: const Color(0xFFE8ECEF),
        onMapReady: () {
          if (mounted) setState(() => _ready = true);
        },
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: tileUrl,
          userAgentPackageName: 'com.emapat.hydra',
          maxNativeZoom: 20,
          // Use real @2x images, keeping the map scale and labels unchanged.
          // Avoid simulated retina for providers that have no {r} support.
          retinaMode:
              tileUrl.contains('{r}') && RetinaMode.isHighDensity(context),
          tileProvider: widget.tileProvider,
        ),
        MarkerLayer(markers: [
          Marker(
            point: widget.location,
            width: 44,
            height: 44,
            alignment: Alignment.topCenter,
            child: Semantics(
              label: 'Ubicación registrada del trabajo',
              child: Icon(Icons.location_on,
                  color: c.primary,
                  size: 42,
                  shadows: const [Shadow(color: Colors.white, blurRadius: 4)]),
            ),
          ),
        ]),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              if (!widget.fullScreen) ...[
                _control(c, 'Ampliar mapa', Icons.fullscreen_rounded,
                    _ready ? _expand : null),
                const SizedBox(height: 8),
              ],
              _control(
                  c,
                  'Centrar en la ubicación registrada',
                  Icons.my_location_rounded,
                  _ready
                      ? () => _controller.move(
                          widget.location, _controller.camera.zoom)
                      : null),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: IgnorePointer(
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('© OpenStreetMap contributors, © CARTO',
                  style: TextStyle(color: Color(0xFF334155), fontSize: 10)),
            ),
          ),
        ),
      ],
    );
    if (widget.fullScreen) return map;
    return LayoutBuilder(builder: (context, constraints) {
      // More geographic area at the same zoom, on both phones and tablets.
      final height = (constraints.maxWidth * 0.6).clamp(300.0, 420.0);
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(height: height, width: double.infinity, child: map),
      );
    });
  }

  Widget _control(
      AppColors c, String label, IconData icon, VoidCallback? onPressed) {
    return Material(
      color: c.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: IconButton(
        tooltip: label,
        color: c.primary,
        style: IconButton.styleFrom(
          backgroundColor: c.surface,
          side: BorderSide(color: c.border.withValues(alpha: 0.55)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        onPressed: onPressed,
        icon: Icon(icon, size: 23),
      ),
    );
  }
}
