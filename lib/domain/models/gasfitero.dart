import 'package:freezed_annotation/freezed_annotation.dart';

part 'gasfitero.freezed.dart';

@freezed
class Gasfitero with _$Gasfitero {
  const factory Gasfitero({
    required int id,
    String? nombre,
    String? codigoEmpleado,
    String? cargo,
    String? area,
  }) = _Gasfitero;
}
