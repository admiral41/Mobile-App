import 'package:bigtalk/config/constants/provider/activity_filter_provider.dart';
import 'package:bigtalk/features/activity/domain/entity/activity_entity.dart';
import 'package:bigtalk/features/activity/presentation/activity_viewmodel/activity_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends ConsumerState<FavoriteView> {
  final List<String> filterList = ["All", "Follows", "Likes", "Replies"];
  late ActivityViewModel activityViewModel;
  final List<Widget> filterWidget = [
    AllWidget(),
    FollowsWidget(),
    LikesWidget(),
    RepliesWidget(),
  ];

  @override
  void initState() {
    super.initState();
    activityViewModel = ref.read(activityViewModelProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final activityFilter = ref.watch(activityFilterProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              expandedHeight: 110.0,
              elevation: 0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(filterList.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          ref.read(activityFilterProvider).changeindex(index);
                          activityViewModel.getActivities(filterList[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 20),
                          height: 35,
                          width: 120,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: activityFilter.index == index
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: activityFilter.index == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          child: Text(
                            filterList[index],
                            style: TextStyle(
                              color: activityFilter.index == index
                                  ? Colors.black
                                  : Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                background: Container(
                  height: 20,
                  width: 100,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ),
                  ),
                  child: const SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Activity",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: filterWidget[activityFilter.index],
      ),
    );
  }
}

Widget FollowsWidget() {
  return Consumer(
    builder: (context, ref, _) {
      final activityState = ref.watch(activityViewModelProvider);
      print("Activity State: $activityState"); // Add this line for debugging

      if (activityState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (activityState.error != null) {
        return Center(
          child: Text(
            'Error: ${activityState.error}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        final followActivities = activityState.activities
            .where((activity) => activity.actionType == "following")
            .toList();

        if (followActivities.isEmpty) {
          return const Center(
            child: Text(
              "No Follow activities to show.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: followActivities.length,
          itemBuilder: (context, index) {
            final activity = followActivities[index];
            print(
                "Rendering activity: $activity"); // Log the activity being rendered
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  "${activity.targetUser?.name} started following you.",
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formatTimestamp(activity.createdAt),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

Widget LikesWidget() {
  return Consumer(
    builder: (context, ref, _) {
      final activityState = ref.watch(activityViewModelProvider);
      print("Activity State: $activityState"); // Add this line for debugging

      if (activityState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (activityState.error != null) {
        return Center(
          child: Text(
            'Error: ${activityState.error}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        final likeActivities = activityState.activities
            .where((activity) => activity.actionType == "likes")
            .toList();

        if (likeActivities.isEmpty) {
          return const Center(
            child: Text(
              "No Likes activities to show.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: likeActivities.length,
          itemBuilder: (context, index) {
            final activity = likeActivities[index];
            print(
                "Rendering activity: $activity"); // Log the activity being rendered
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  "${activity.targetUser?.name} liked your post.",
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formatTimestamp(activity.createdAt),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

Widget RepliesWidget() {
  return Consumer(
    builder: (context, ref, _) {
      final activityState = ref.watch(activityViewModelProvider);
      print("Activity State: $activityState"); // Add this line for debugging

      if (activityState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (activityState.error != null) {
        return Center(
          child: Text(
            'Error: ${activityState.error}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        final replyActivities = activityState.activities
            .where((activity) => activity.actionType == "reply")
            .toList();

        if (replyActivities.isEmpty) {
          return const Center(
            child: Text(
              "No Replies activities to show.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: replyActivities.length,
          itemBuilder: (context, index) {
            final activity = replyActivities[index];
            print(
                "Rendering activity: $activity"); // Log the activity being rendered
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  "${activity.targetUser?.name} commented on your post.",
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formatTimestamp(activity.createdAt),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

Widget AllWidget() {
  return Consumer(
    builder: (context, ref, _) {
      final activityState = ref.watch(activityViewModelProvider);
      print("Activity State: $activityState"); // Add this line for debugging

      if (activityState.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (activityState.error != null) {
        return Center(
          child: Text(
            'Error: ${activityState.error}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        print("Activities length: ${activityState.activities.length}");
        print("Activities: ${activityState.activities}");

        if (activityState.activities.isEmpty) {
          return const Center(
            child: Text(
              "No activities to show.",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: activityState.activities.length,
          itemBuilder: (context, index) {
            final activity = activityState.activities[index];
            print(
                "Rendering activity: $activity"); // Log the activity being rendered
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  activity.targetUser?.name ?? "Unknown User",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  renderActivityMessage(activity) ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  formatTimestamp(activity.createdAt),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    },
  );
}

String renderActivityMessage(ActivityEntity activity) {
  if (activity.actionType == "following") {
    return "${activity.targetUser!.name} started following you.";
  } else if (activity.actionType == "likes") {
    return "${activity.targetUser!.name} liked your post.";
  } else if (activity.actionType == "reply") {
    return "${activity.targetUser!.name} commented on your post.";
  }
  return ""; // Add other cases if needed
}

String formatTimestamp(String timestamp) {
  DateTime postTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  Duration difference = now.difference(postTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return '${difference.inDays} days ago';
  }
}
