import '../cmn.dart';
part 'mo_response.g.dart';

@JsonSerializable()
class MoResponse {
  String? status, message;
  bool? success;
  num? ttl, createdAt;
  List<dynamic>? result, res;

  // dynamic response;

  MoResponse({this.status, this.success, this.message, this.result, this.res, this.ttl, this.createdAt});

  factory MoResponse.fromJson(Map<String, dynamic> json) => _$MoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoResponseToJson(this);
}
