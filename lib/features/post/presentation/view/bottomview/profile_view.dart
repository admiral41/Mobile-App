import 'package:bigtalk/core/common/snackbar/my_snackbar.dart';
import 'package:bigtalk/core/failure/failure.dart';
import 'package:bigtalk/core/shared_prefs/user_shared_prefs.dart';
import 'package:bigtalk/core/utils/text_util.dart';
import 'package:bigtalk/features/auth/presentation/auth_viewmodel/getUser_viewmodel.dart';
import 'package:bigtalk/features/post/presentation/view/bottomview/dashboard_view.dart';
import 'package:bigtalk/features/post/presentation/view/bottomview/post_details_view.dart';
import 'package:bigtalk/features/post/presentation/view_model/post_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String userId = "";
  String id = "";
  bool isLiked = false;

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

  bool _showBigTalks = true;
  late getUserViewModel authViewModel;
  @override
  void initState() {
    super.initState();
    // setUser();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userSharedPrefs = ref.read(userSharedPrefsProvider);
      Either<Failure, String?> user = await userSharedPrefs.getUserId();

      user.fold((failure) => {}, (user) {
        print(user);
        setState(() {
          userId = user ?? "";
        });
        ref.read(getUserViewModelProvider.notifier).getUsersById(user);
        ref.read(postViewModelProvider.notifier).getPostByUserIdApi(user!);
        ref
            .watch(postViewModelProvider.notifier)
            .getPostsByUserCommentsApi(user);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // authViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authState = ref.watch(getUserViewModelProvider);
    final postState = ref.watch(postViewModelProvider);
    final postViewModel = ref.read(postViewModelProvider.notifier);
    final userSharedPrefs = ref.read(userSharedPrefsProvider);
    final user = authState.user;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // or any other loading indicator
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TitleText(
                      text: user.username ?? 'test',
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/no-user.png"),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NormalText(
                    text: "${user.followers!.length} followers",
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  NormalText(
                    text: "${user.following!.length} following",
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showBigTalks = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: _showBigTalks
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent)),
                        ),
                        alignment: Alignment.center,
                        child: TitleText(
                          text: "BigTalks",
                          color: _showBigTalks ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showBigTalks = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: !_showBigTalks
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent)),
                        ),
                        alignment: Alignment.center,
                        child: TitleText(
                          text: "Replies",
                          color: !_showBigTalks ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_showBigTalks)
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2))),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return ref
                              .watch(postViewModelProvider.notifier)
                              .getPostByUserIdApi(userId);
                        },
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            if (postState.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (postState.error != null)
                              Center(child: Text('Error: ${postState.message}'))
                            else if (postState.posts.isEmpty)
                              const Center(
                                  child: Text(
                                'No posts to show.',
                                style: TextStyle(color: Colors.white),
                              ))
                            else
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: postState.posts.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final post = postState.posts[index];
                                  String name = post.owner?.name ?? 'Unknown';
                                  String time =
                                      formatTimestamp(post.createdAt ?? '');
                                  String content = post.caption ?? 'No caption';
                                  List<String>? contentImages = post.image;
                                  int replyCount = post.comments?.length ?? 0;
                                  int likeCount = post.likes?.length ?? 0;
                                  isLiked = post.likes!.contains(userId);
                                  print('isLiked:$isLiked');
                                  print('liked user id: $userId');

                                  bool isOwner = post.owner?.id == userId;

                                  // Check if the post has comments by the current user
                                  bool hasUserCommented = post.comments?.any(
                                          (comment) =>
                                              comment.owner?.id == userId) ??
                                      false;

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
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.2),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (post.owner?.avatar !=
                                                      'null' &&
                                                  post.owner!.avatar!.url
                                                      .isNotEmpty)
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      post.owner!.avatar!.url),
                                                )
                                              else
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[300],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      getInitials(name),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          time,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        if (isOwner)
                                                          GestureDetector(
                                                            onTap: () {
                                                              showmoresheet(
                                                                context,
                                                                postId:
                                                                    post.id!,
                                                                postViewModel:
                                                                    postViewModel,
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10,
                                                              top: 5),
                                                      child: Text(
                                                        content,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    if (contentImages!
                                                        .isNotEmpty)
                                                      Column(
                                                        children: contentImages
                                                            .map((image) {
                                                          return ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child:
                                                                Image.network(
                                                                    image),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (!isLiked) {
                                                              print(
                                                                  "IS LIKED:::");
                                                              ref
                                                                  .read(postViewModelProvider
                                                                      .notifier)
                                                                  .likePost(
                                                                      post.id!);
                                                              showSnackBar(
                                                                message:
                                                                    'Post Liked',
                                                                context:
                                                                    context,
                                                                color: Colors
                                                                    .green,
                                                              );
                                                            } else {
                                                              print(
                                                                  "IS LIKED:::111");
                                                              ref
                                                                  .read(postViewModelProvider
                                                                      .notifier)
                                                                  .dislikePost(
                                                                      post.id!);
                                                              showSnackBar(
                                                                message:
                                                                    'Post Unliked',
                                                                context:
                                                                    context,
                                                                color:
                                                                    Colors.red,
                                                              );
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              right: 15,
                                                            ),
                                                            child: Icon(
                                                              isLiked
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
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
                                                            print(post
                                                                .owner?.name);
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 15),
                                                            child: Icon(
                                                              Icons
                                                                  .chat_bubble_outline,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            // Handle share action
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 15),
                                                            child: Icon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.orange,
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
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          "$likeCount likes ",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
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
                  ],
                )
              else
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.2),
                        ),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return ref
                              .watch(postViewModelProvider.notifier)
                              .getPostsByUserCommentsApi(userId);
                        },
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          children: [
                            if (postState.isLoading)
                              const Center(child: CircularProgressIndicator())
                            else if (postState.error != null)
                              Center(child: Text('Error: ${postState.message}'))
                            else if (postState.userComment!.isEmpty)
                              const Center(
                                  child: Text(
                                'No comments to show.',
                                style: TextStyle(color: Colors.white),
                              ))
                            else
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: postState.userComment!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final post = postState.userComment![index];
                                  String name = post.owner?.name ?? 'Unknown';
                                  String time =
                                      formatTimestamp(post.createdAt ?? '');
                                  String content = post.caption ?? 'No caption';
                                  List<String>? contentImages = post.image;
                                  int replyCount = post.comments?.length ?? 0;
                                  int likeCount = post.likes?.length ?? 0;
                                  bool isLiked = post.likes!.contains(userId);

                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetailScreen(
                                                post: post,
                                               
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 0.2),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (post.owner?.avatar !=
                                                          'null' &&
                                                      post.owner!.avatar!.url
                                                          .isNotEmpty)
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(post
                                                              .owner!
                                                              .avatar!
                                                              .url),
                                                    )
                                                  else
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[300],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          getInitials(name),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                name,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            Text(
                                                              time,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 10,
                                                                  top: 5),
                                                          child: Text(
                                                            content,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        if (contentImages!
                                                            .isNotEmpty)
                                                          Column(
                                                            children:
                                                                contentImages
                                                                    .map(
                                                                        (image) {
                                                              return ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Image
                                                                    .network(
                                                                        image),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (!isLiked) {
                                                                  ref
                                                                      .read(postViewModelProvider
                                                                          .notifier)
                                                                      .likePost(
                                                                          post.id!);
                                                                  showSnackBar(
                                                                    message:
                                                                        'Post Liked',
                                                                    context:
                                                                        context,
                                                                    color: Colors
                                                                        .green,
                                                                  );
                                                                } else {
                                                                  ref
                                                                      .read(postViewModelProvider
                                                                          .notifier)
                                                                      .dislikePost(
                                                                          post.id!);
                                                                  showSnackBar(
                                                                    message:
                                                                        'Post Unliked',
                                                                    context:
                                                                        context,
                                                                    color: Colors
                                                                        .red,
                                                                  );
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            15),
                                                                child: Icon(
                                                                  isLiked
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border,
                                                                  color: isLiked
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showCommentSheet(
                                                                  context:
                                                                      context,
                                                                  postId:
                                                                      post.id!,
                                                                  postViewModel:
                                                                      postViewModel,
                                                                );
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            15),
                                                                child: Icon(
                                                                  Icons
                                                                      .chat_bubble_outline,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                // Handle share action
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            15),
                                                                child: Icon(
                                                                  Icons.share,
                                                                  color: Colors
                                                                      .orange,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "$replyCount replies ",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            Text(
                                                              "$likeCount likes ",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                      ],
                                                    ),
                                                  ),
                                                ],
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
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
