// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoResponse _$MoResponseFromJson(Map<String, dynamic> json) => MoResponse(
      status: json['status'] as String?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      result: json['result'] as List<dynamic>?,
      res: json['res'] as List<dynamic>?,
      ttl: json['ttl'] as num?,
      createdAt: json['createdAt'] as num?,
    );

Map<String, dynamic> _$MoResponseToJson(MoResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('message', instance.message);
  writeNotNull('success', instance.success);
  writeNotNull('ttl', instance.ttl);
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('result', instance.result);
  writeNotNull('res', instance.res);
  return val;
}
