class ApiEndpoints {
  ApiEndpoints._();
  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  // For Windows
  static const String baseUrl = "http://10.0.2.2:5000/api/v1/";

  // static const String baseUrl = "http://192.168.137.1:5000/api/v1/";

  // ====================== Auth Routes ======================
  static const String login = "login";
  static const String register = "register";
  static const String search = "search";
  static const String followAndUnfollow = "follow/:id";
  static const String getUserById = "user/:id";

  // ====================== Post Routes ======================
  static const String createPosts = "post/upload";
  static const String getPostOfFollowingUsers = "posts";
  static const String likeAndUnlikePost = "post/:id}";
  static const String deletePost = "post/delete/:id";
  static const String getPostByUserID = "post/user/:userId";
  static const String createComment = "/post/comment/:id";
  static const String getPostsByUserCommentsApi = "user/";
  static const String getPostByUserIdApi = "post/user/";
  static const String getCommentByPostID = "/post/comment/:id";
  // ====================== Activity Routes ======================
  static const String getActivityAll = "activities/all";
  static const String getActivityReplies = "activities/reply";
  static const String getActivityLikes = "activities/likes";
  static const String getActivityFollowing = "activities/following";
}
