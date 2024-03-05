import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/core/utils/buttomsheets/buttomsheet_util.dart';
import 'package:bigtalk/features/post/presentation/view/bottomview/post_details_view.dart';
import 'package:bigtalk/features/post/presentation/view_model/post_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isLiked = false;
  String userId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUser();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(postViewModelProvider.notifier).getPostsOfFollowingUsers();
    });
  }

  void setUser() async {
    final userSharedPrefs = ref.read(userSharedPrefsProvider);
    Either<Failure, String?> user = await userSharedPrefs.getUserId();

    user.fold((failure) => {}, (user) {
      print(user);
      setState(() {
        userId = user ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postViewModelProvider);
    final postViewModel = ref.read(postViewModelProvider.notifier);
    final userSharedPrefs = ref.read(userSharedPrefsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return ref
                .watch(postViewModelProvider.notifier)
                .getPostsOfFollowingUsers();
          },
          child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              if (postState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (postState.error != null)
                Center(child: Text('Error: ${postState.message}'))
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postState.posts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final post = postState.posts[index];
                    String name = post.owner?.name ?? 'Unknown';
                    String time = formatTimestamp(post.createdAt ?? '');
                    String content = post.caption ?? 'No caption';
                    List<String>? contentImages = post.image;
                    int replyCount = post.comments?.length ?? 0;
                    int likeCount = post.likes?.length ?? 0;
                    isLiked = post.likes!.contains(userId);
                    print('isLiked:$isLiked');
                    print('liked user id: $userId');

                    bool isOwner = post.owner?.id == userId;

                    print('isliked? $isLiked $userId');

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(post: post),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (post.owner?.avatar != 'null' &&
                                    post.owner!.avatar!.url.isNotEmpty)
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.owner!.avatar!.url),
                                  )
                                else
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[300],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        getInitials(name),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            time,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(width: 10),
                                          if (isOwner)
                                            GestureDetector(
                                              onTap: () {
                                                showmoresheet(
                                                  context,
                                                  postId: post.id!,
                                                  postViewModel: postViewModel,
                                                );
                                              },
                                              child: const Icon(
                                                Icons.more_horiz,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 10, top: 5),
                                        child: Text(
                                          content,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      if (contentImages != null &&
                                          contentImages.isNotEmpty)
                                        Column(
                                          children: contentImages.map((image) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(image),
                                            );
                                          }).toList(),
                                        ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (!isLiked) {
                                                print("IS LIKED:::");
                                                ref
                                                    .read(postViewModelProvider
                                                        .notifier)
                                                    .likePost(post.id!);
                                                showSnackBar(
                                                  message: 'Post Liked',
                                                  context: context,
                                                  color: Colors.green,
                                                );
                                              } else {
                                                print("IS LIKED:::111");
                                                ref
                                                    .read(postViewModelProvider
                                                        .notifier)
                                                    .dislikePost(post.id!);
                                                showSnackBar(
                                                  message: 'Post Unliked',
                                                  context: context,
                                                  color: Colors.red,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15,
                                              ),
                                              child: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isLiked
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showCommentSheet(
                                                context: context,
                                                postId: post.id!,
                                                postViewModel:
                                                    postViewModel, // Pass the postViewModel to the sheet
                                              );
                                              print(post.id);
                                              print(post.owner?.name);
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.chat_bubble_outline,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Handle share action
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.share,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text(
                                            "$replyCount replies ",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "$likeCount likes ",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 55),
                            alignment: Alignment.centerLeft,
                            child: const VerticalDivider(
                              thickness: 2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void showCommentSheet({
  required BuildContext context,
  required String postId,
  required PostViewModel postViewModel,
}) {
  TextEditingController commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add a Comment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Enter your comment here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null, // Allow multiline input
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle comment submission
                  final commentText = commentController.text.trim();
                  if (commentText.isNotEmpty) {
                    postViewModel.createComment(postId, commentText);
                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    // Show an error or inform the user to enter a comment
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a comment'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14), // Button padding
                ),
                child: const Text(
                  'Post Comment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showmoresheet(BuildContext context,
    {required String postId, required PostViewModel postViewModel}) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setmodelState) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  postViewModel.deletePost(context, postId);
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: Column(
                    children: [
                      sheetitem(
                        "Delete",
                        context,
                        0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    },
  );
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

String getInitials(String name) {
  if (name.isEmpty) return '';

  List<String> names = name.split(" ");
  String initials = '';
  int numWords = names.length > 2 ? 2 : names.length;

  for (int i = 0; i < numWords; i++) {
    initials += names[i][0];
  }

  return initials.toUpperCase();
}
