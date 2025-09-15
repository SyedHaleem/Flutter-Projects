class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String commentText;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.commentText,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userAvatarUrl": userAvatarUrl,
    "commentText": commentText,
    "createdAt": createdAt.toIso8601String(),
  };

  static CommentModel fromJson(Map<String, dynamic> json, String id) => CommentModel(
    id: id,
    userId: json["userId"] ?? "",
    userName: json["userName"] ?? "",
    userAvatarUrl: json["userAvatarUrl"] ?? "",
    commentText: json["commentText"] ?? "",
    createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
  );
}