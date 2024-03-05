import 'package:bigtalk/features/activity/domain/use_case/activity_use_case.dart';
import 'package:bigtalk/features/activity/presentation/state/activity_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityViewModelProvider =
    StateNotifierProvider<ActivityViewModel, ActivityState>(
  (ref) => ActivityViewModel(ref.read(activityUseCaseProvider)),
);

class ActivityViewModel extends StateNotifier<ActivityState> {
  final ActivityUseCase activityUseCase;

  ActivityViewModel(this.activityUseCase) : super(ActivityState.initial()) {
    print('dsafjdklsafldksafldkas activity');

    getActivities('All'); // Initially, 'All' tab is selected
  }

  getActivities(String tab) async {
    state = state.copyWith(isLoading: true);
    final result = await activityUseCase.getActivity(tab);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        isError: true,
        message: failure.message,
      ),
      (activities) => state = state.copyWith(
        isLoading: false,
        activities: activities,
      ),
    );
  }
}
