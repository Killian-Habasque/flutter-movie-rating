class UserModel {
  final int id;
  final String name;
  final String username;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar']['tmdb']?['avatar_path'] != null
          ? "https://image.tmdb.org/t/p/w500${json['avatar']['tmdb']['avatar_path']}"
          : null,
    );
  }
}
