import 'package:freezed_annotation/freezed_annotation.dart';

part 'sector.freezed.dart';

@freezed
class Sector with _$Sector {
  const factory Sector({
    required int id,
    String? nombre,
    String? reservorioAsociado,
    String? geometriaGeojson,
  }) = _Sector;
}
