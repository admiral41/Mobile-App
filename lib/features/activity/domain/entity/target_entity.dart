import 'package:equatable/equatable.dart';

class TargetUserEntity extends Equatable {
  final String? id;
  final String? name;

  const TargetUserEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory TargetUserEntity.fromJson(Map<String, dynamic> json) =>
      TargetUserEntity(
        id: json['_id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}
