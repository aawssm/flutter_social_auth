
import '../models/mo_user_auth_pro.dart';

import '../cmn.dart';
part 'mo_user_profile.g.dart';

@JsonSerializable()
class MoUserProfile {
  //user/userPublic/uid
  @JsonKey(name: '_id')
  String? id;
  String? name, email, password, token, givenName, middleName, familyName, username, profilePic;
  bool? isVerified;
  int? status, lastOnline, dateJoin;
  List<MoUserAuthPro>? providers;
  MoUserProfile(
      {this.id,
      this.name,
      this.password,
      this.token,
      this.email,
      this.isVerified,
      this.status,
      this.lastOnline,
      this.dateJoin,
      this.providers});

  factory MoUserProfile.fromJson(Map<String, dynamic> json) => _$MoUserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MoUserProfileToJson(this);
}
