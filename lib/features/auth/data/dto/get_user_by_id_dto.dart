import 'package:bigtalk/features/auth/data/model/auth_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_by_id_dto.g.dart';

@JsonSerializable()
class GetUserByIdDto {
  final bool success;
  final String? message;
  @JsonKey(name: 'user')
  final AuthApiModel? user;

  GetUserByIdDto({required this.success, this.message, required this.user});

  factory GetUserByIdDto.fromJson(Map<String, dynamic> json) =>
      _$GetUserByIdDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserByIdDtoToJson(this);
}
