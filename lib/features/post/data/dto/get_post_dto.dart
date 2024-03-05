import 'package:bigtalk/features/post/data/model/post_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_post_dto.g.dart';

@JsonSerializable()
class GetPostDTO {
  final bool success;
  final int? count;
  final List<PostApiModel> posts;

  const GetPostDTO({
    required this.success,
    this.count,
    required this.posts,
  });

  factory GetPostDTO.fromJson(Map<String, dynamic> json) =>
      _$GetPostDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetPostDTOToJson(this);
}
