import '../cmn.dart';
part 'mo_user_auth_pro.g.dart';

@JsonSerializable()
class MoUserAuthPro {  
  String? provider, accessToken, refreshToken, id, username, email;
  bool? isVerified;
  MoUserAuthPro(
      {this.provider,
      this.accessToken,
      this.refreshToken,
      this.id,
      this.username,
      this.email,
      this.isVerified});
  factory MoUserAuthPro.fromJson(Map<String, dynamic> json) => _$MoUserAuthProFromJson(json);

  Map<String, dynamic> toJson() => _$MoUserAuthProToJson(this);
}
