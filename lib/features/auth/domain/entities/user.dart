class User {
  final int id;
  final String name;
  final String username;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.username,
    this.avatarUrl,
  });
} 