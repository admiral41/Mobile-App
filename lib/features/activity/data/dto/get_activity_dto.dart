import 'package:bigtalk/features/activity/data/model/activity_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_activity_dto.g.dart';

@JsonSerializable()
class GetActivityDTO {
  final bool success;
  final int? count;
  final List<ActivityApiModel> activities;
  GetActivityDTO(
      {required this.success, required this.count, required this.activities});

  factory GetActivityDTO.fromJson(Map<String, dynamic> json) =>
      _$GetActivityDTOFromJson(json);
  Map<String, dynamic> toJson() => _$GetActivityDTOToJson(this);
}
