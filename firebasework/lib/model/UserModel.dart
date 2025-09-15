class UserModel {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final String email;

  UserModel({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
    "userName": userName,
    "userAvatarUrl": userAvatarUrl,
    "email": email,
  };

  static UserModel fromJson(Map<String, dynamic> json, String id) => UserModel(
    id: id,
    userName: json["userName"] ?? "",
    userAvatarUrl: json["userAvatarUrl"] ?? "",
    email: json["email"] ?? "",
  );
}