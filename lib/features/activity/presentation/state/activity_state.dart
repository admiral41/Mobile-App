import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';

class ActivityState {
  final bool isLoading;
  final String? error;
  final String message;
  final List<ActivityEntity> activities;

  ActivityState(
      {required this.isLoading,
      required this.error,
      required this.message,
      required this.activities});

  factory ActivityState.initial() {
    return ActivityState(
      isLoading: false,
      error: null,
      message: '',
      activities: [],
    );
  }

  ActivityState copyWith({
    bool? isLoading,
    bool? isError,
    String? message,
    List<ActivityEntity>? activities,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? error,
      message: message ?? this.message,
      activities: activities ?? this.activities,
    );
  }
}
