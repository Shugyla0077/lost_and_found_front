class UserProfile {
  final String uid;
  final String? email;
  final String displayName;
  final String city;
  final String about;
  final String language;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.city,
    required this.about,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return UserProfile(
      uid: (json['uid'] ?? '').toString(),
      email: json['email'] as String?,
      displayName: (json['display_name'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      about: (json['about'] ?? '').toString(),
      language: (json['language'] ?? 'en').toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'display_name': displayName,
      'city': city,
      'about': about,
      'language': language,
    };
  }
}
