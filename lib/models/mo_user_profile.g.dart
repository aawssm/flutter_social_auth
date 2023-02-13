// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mo_user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoUserProfile _$MoUserProfileFromJson(Map<String, dynamic> json) =>
    MoUserProfile(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      email: json['email'] as String?,
      isVerified: json['isVerified'] as bool?,
      status: json['status'] as int?,
      lastOnline: json['lastOnline'] as int?,
      dateJoin: json['dateJoin'] as int?,
      providers: (json['providers'] as List<dynamic>?)
          ?.map((e) => MoUserAuthPro.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..givenName = json['givenName'] as String?
      ..middleName = json['middleName'] as String?
      ..familyName = json['familyName'] as String?
      ..username = json['username'] as String?
      ..profilePic = json['profilePic'] as String?;

Map<String, dynamic> _$MoUserProfileToJson(MoUserProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  writeNotNull('token', instance.token);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('middleName', instance.middleName);
  writeNotNull('familyName', instance.familyName);
  writeNotNull('username', instance.username);
  writeNotNull('profilePic', instance.profilePic);
  writeNotNull('isVerified', instance.isVerified);
  writeNotNull('status', instance.status);
  writeNotNull('lastOnline', instance.lastOnline);
  writeNotNull('dateJoin', instance.dateJoin);
  writeNotNull(
      'providers', instance.providers?.map((e) => e.toJson()).toList());
  return val;
}
