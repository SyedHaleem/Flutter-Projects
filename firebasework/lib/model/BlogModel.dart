class BlogModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String blogTitle;
  final String blogSubtitle;
  final String blogCoverUrl;
  final int readTimeMinutes;
  final DateTime createdAt;
  final int likes;
  final List<String> likedUserIds;
  final List<String> bookmarkedUserIds;
  final String category; // <-- NEW FIELD

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  bool isLikedBy(String currentUserId) => likedUserIds.contains(currentUserId);
  bool isBookmarkedBy(String currentUserId) => bookmarkedUserIds.contains(currentUserId);

  BlogModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.blogTitle,
    required this.blogSubtitle,
    required this.blogCoverUrl,
    required this.readTimeMinutes,
    required this.createdAt,
    required this.likes,
    required this.likedUserIds,
    required this.bookmarkedUserIds,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userAvatarUrl": userAvatarUrl,
    "blogTitle": blogTitle,
    "blogSubtitle": blogSubtitle,
    "blogCoverUrl": blogCoverUrl,
    "readTimeMinutes": readTimeMinutes,
    "createdAt": createdAt.toIso8601String(),
    "likes": likes,
    "likedUserIds": likedUserIds,
    "bookmarkedUserIds": bookmarkedUserIds,
    "category": category,
  };

  static BlogModel fromJson(Map<String, dynamic> json, String id) => BlogModel(
    id: id,
    userId: json["userId"] ?? "",
    userName: json["userName"] ?? "",
    userAvatarUrl: json["userAvatarUrl"] ?? "",
    blogTitle: json["blogTitle"] ?? "",
    blogSubtitle: json["blogSubtitle"] ?? "",
    blogCoverUrl: json["blogCoverUrl"] ?? "",
    readTimeMinutes: json["readTimeMinutes"] ?? 0,
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    likes: json["likes"] ?? 0,
    likedUserIds: List<String>.from(json["likedUserIds"] ?? []),
    bookmarkedUserIds: List<String>.from(json["bookmarkedUserIds"] ?? []),
    category: json["category"] ?? "",
  );
}