import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile.dart';

abstract class ProfileService {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile({
    String? displayName,
    String? city,
    String? about,
    String? language,
  });
}

class ProfileServiceImpl implements ProfileService {
  ProfileServiceImpl(this._dio);

  final Dio _dio;

  Future<String> _requireToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated. Please sign in.');
    }
    final token = await user.getIdToken(true);
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated. Please sign in.');
    }
    return token;
  }

  @override
  Future<UserProfile> getProfile() async {
    final token = await _requireToken();
    final res = await _dio.get(
      '/profile/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<UserProfile> updateProfile({
    String? displayName,
    String? city,
    String? about,
    String? language,
  }) async {
    final token = await _requireToken();
    final res = await _dio.patch(
      '/profile/',
      data: {
        if (displayName != null) 'display_name': displayName,
        if (city != null) 'city': city,
        if (about != null) 'about': about,
        if (language != null) 'language': language,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }
}
