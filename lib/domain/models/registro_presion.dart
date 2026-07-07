import 'package:freezed_annotation/freezed_annotation.dart';

part 'registro_presion.freezed.dart';

@freezed
class RegistroPresion with _$RegistroPresion {
  const factory RegistroPresion({
    String? fechaHora,
    double? presionMca,
    double? temperaturaC,
    String? dispositivoSerie,
  }) = _RegistroPresion;
}
