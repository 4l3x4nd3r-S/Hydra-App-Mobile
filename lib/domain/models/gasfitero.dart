import 'package:freezed_annotation/freezed_annotation.dart';

part 'gasfitero.freezed.dart';

@freezed
class Gasfitero with _$Gasfitero {
  const factory Gasfitero({
    required int id,
    String? nombre,
    String? codigoEmpleado,
    String? dni,
    String? celular,
    String? cargo,
    String? cargoVisible,
    String? area,
    String? areaVisible,
    String? rolEnCuadrilla,
    String? funcionVisible,
    @Default(false) bool esPrincipal,
    @Default(false) bool puedeSerGasfitero,
    @Default(false) bool puedeSerChofer,
    int? cuadrillaId,
    String? codigoCuadrilla,
  }) = _Gasfitero;
}
