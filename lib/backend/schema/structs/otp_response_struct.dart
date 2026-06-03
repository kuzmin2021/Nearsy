// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/floter/floter_util.dart';

/// Minimal response wrapper for Supabase OTP REST calls.
class OtpResponseStruct extends BaseStruct {
  OtpResponseStruct({
    /// OtpResponse.message
    String? message,
  }) : _message = message;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;

  bool hasMessage() => _message != null;

  static OtpResponseStruct fromMap(Map<String, dynamic> data) =>
      OtpResponseStruct(
        message: data['message'] as String?,
      );

  static OtpResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? OtpResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'message': _message,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
      }.withoutNulls;

  static OtpResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      OtpResponseStruct(
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OtpResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OtpResponseStruct && message == other.message;
  }

  @override
  int get hashCode => const ListEquality().hash([message]);
}

OtpResponseStruct createOtpResponseStruct({
  String? message,
}) =>
    OtpResponseStruct(
      message: message,
    );
