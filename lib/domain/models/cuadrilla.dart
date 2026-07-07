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
    Gasfitero? operador,
  }) = _Cuadrilla;
}
