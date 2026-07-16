import 'package:freezed_annotation/freezed_annotation.dart';

part 'responsable_dto.freezed.dart';
part 'responsable_dto.g.dart';

@freezed
class ResponsableDto with _$ResponsableDto {
  const factory ResponsableDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'nombre') String? nombre,
    @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
    @JsonKey(name: 'cargo') String? cargo,
  }) = _ResponsableDto;

  factory ResponsableDto.fromJson(Map<String, dynamic> json) =>
      _$ResponsableDtoFromJson(json);
}
