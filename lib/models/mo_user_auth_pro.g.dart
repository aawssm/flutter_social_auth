// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mo_user_auth_pro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoUserAuthPro _$MoUserAuthProFromJson(Map<String, dynamic> json) =>
    MoUserAuthPro(
      provider: json['provider'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      id: json['id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$MoUserAuthProToJson(MoUserAuthPro instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('provider', instance.provider);
  writeNotNull('accessToken', instance.accessToken);
  writeNotNull('refreshToken', instance.refreshToken);
  writeNotNull('id', instance.id);
  writeNotNull('username', instance.username);
  writeNotNull('email', instance.email);
  writeNotNull('isVerified', instance.isVerified);
  return val;
}
