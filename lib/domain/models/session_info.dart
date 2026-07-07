import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_info.freezed.dart';

@freezed
class SessionInfo with _$SessionInfo {
  const factory SessionInfo({
    required bool valido,
    required String rol,
    required String? nombre,
  }) = _SessionInfo;
}
