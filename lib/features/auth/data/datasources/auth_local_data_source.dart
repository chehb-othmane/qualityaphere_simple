import 'dart:convert';

import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String cachedUserKey = 'CACHED_AUTH_USER';

abstract class AuthLocalDataSource {
  /// Retourne le dernier utilisateur stocké,
  /// ou null s'il n'existe pas.
  ///
  /// Throws [CacheException] en cas d'erreur de parsing.
  Future<UserModel?> getCachedUser();

  /// Met en cache les infos utilisateur (par ex. après login/register).
  ///
  /// Throws [CacheException] en cas d'échec.
  Future<void> cacheUser(UserModel user);

  /// Efface la session locale (logout).
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = prefs.getString(cachedUserKey);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonMap =
          json.decode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(jsonMap);
    } catch (e) {
      throw CacheException('Failed to read cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toJson());
      final success = await prefs.setString(cachedUserKey, jsonString);
      if (!success) {
        throw CacheException('Failed to save cached user');
      }
    } catch (e) {
      throw CacheException('Failed to save cached user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(cachedUserKey);
  }
}
