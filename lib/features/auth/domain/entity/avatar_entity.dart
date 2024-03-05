import 'package:equatable/equatable.dart';

class AvatarEntity extends Equatable {
  final String publicId;
  final String url;

  const AvatarEntity({
    required this.publicId,
    required this.url,
  });

  @override
  List<Object?> get props => [publicId, url];

  factory AvatarEntity.fromJson(Map<String, dynamic> json) {
    return AvatarEntity(
      publicId: json['publicId'],
      url: json['url'],
    );
  }
  Map<String, dynamic> toJson() => {
        'publicId': publicId,
        'url': url,
      };
}
