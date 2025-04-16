class CastModel {
  final String name;
  final String character;
  final String profilePath;

  CastModel({
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'] ?? '',
    );
  }
}
