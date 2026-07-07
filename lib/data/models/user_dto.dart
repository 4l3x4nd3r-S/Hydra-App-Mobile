import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'nombre') String? nombre,
    @JsonKey(name: 'codigo_empleado') String? codigoEmpleado,
    @JsonKey(name: 'rol') String? rol,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
