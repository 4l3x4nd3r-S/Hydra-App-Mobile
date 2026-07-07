import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String nombre,
    required String? codigoEmpleado,
    required String rol,
  }) = _User;
}
