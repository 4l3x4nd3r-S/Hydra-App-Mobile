class AppEnvironment {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const mapTileUrl = String.fromEnvironment('MAP_TILE_URL');
  static const mapCenterLatitude =
      String.fromEnvironment('MAP_CENTER_LATITUDE');
  static const mapCenterLongitude =
      String.fromEnvironment('MAP_CENTER_LONGITUDE');

  static void validate() {
    final missing = <String>[
      if (apiBaseUrl.trim().isEmpty) 'API_BASE_URL',
      if (mapTileUrl.trim().isEmpty) 'MAP_TILE_URL',
      if (mapCenterLatitude.trim().isEmpty) 'MAP_CENTER_LATITUDE',
      if (mapCenterLongitude.trim().isEmpty) 'MAP_CENTER_LONGITUDE',
    ];
    if (missing.isNotEmpty) {
      throw StateError(
        'Falta configuración de ambiente: ${missing.join(', ')}',
      );
    }
    double.parse(mapCenterLatitude);
    double.parse(mapCenterLongitude);
  }
}
