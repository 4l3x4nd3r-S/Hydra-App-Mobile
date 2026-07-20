import 'package:freezed_annotation/freezed_annotation.dart';
import 'gasfitero.dart';

part 'cuadrilla.freezed.dart';

@freezed
class Cuadrilla with _$Cuadrilla {
  const factory Cuadrilla({
    required int id,
    String? codigoGrupo,
    String? especialidad,
    Gasfitero? lider,
    @Default([]) List<Gasfitero> apoyos,
    Gasfitero? chofer,
  }) = _Cuadrilla;
}

extension CuadrillaIntegrantes on Cuadrilla {
  int get cantidadIntegrantes => {
        if (lider != null) lider!.id,
        if (chofer != null) chofer!.id,
        ...apoyos.map((integrante) => integrante.id),
      }.length;

  bool get tieneIntegrantesMinimos => cantidadIntegrantes >= 2;
}
