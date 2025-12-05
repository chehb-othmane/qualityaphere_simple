import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel?> getCurrentUser();
  Future<void> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String usersBoxName = 'users_box';
  static const String currentUserEmailKey = 'current_user_email';

  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  Box get _usersBox => Hive.box(usersBoxName);

  @override
  Future<UserModel> login(String email, String password) async {
    final Map<dynamic, dynamic>? userMap = _usersBox
        .get(email)
        ?.cast<dynamic, dynamic>();

    if (userMap == null) {
      throw Exception('User not found');
    }

    final user = UserModel.fromMap(userMap);

    if (user.password != password) {
      throw Exception('Invalid password');
    }

    await sharedPreferences.setString(currentUserEmailKey, email);

    return user;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    if (_usersBox.containsKey(email)) {
      throw Exception('User already exists');
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
    );

    await _usersBox.put(email, newUser.toMap());

    await sharedPreferences.setString(currentUserEmailKey, email);

    return newUser;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final email = sharedPreferences.getString(currentUserEmailKey);
    if (email == null) return null;

    final Map<dynamic, dynamic>? userMap = _usersBox
        .get(email)
        ?.cast<dynamic, dynamic>();

    if (userMap == null) return null;

    return UserModel.fromMap(userMap);
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove(currentUserEmailKey);
  }
}
