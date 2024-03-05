import 'package:equatable/equatable.dart';

class TargetPostEntity extends Equatable {
  final String? id;
  final String? caption;

  const TargetPostEntity({required this.id, required this.caption});
  @override
  List<Object?> get props => [id, caption];

  factory TargetPostEntity.fromJson(Map<String, dynamic> json) =>
      TargetPostEntity(
        id: json['_id'],
        caption: json['caption'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'caption': caption,
      };
}
