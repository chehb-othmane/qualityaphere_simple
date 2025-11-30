import 'package:dio/dio.dart';
import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Throws [ServerException] on non-200 or malformed data.
  Future<UserModel> login({required String email, required String password});

  /// Throws [ServerException].
  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        '$baseUrl/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          response.data as Map,
        );
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      } else {
        throw ServerException('Invalid status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await client.post(
        '$baseUrl/auth/register',
        data: {'email': email, 'password': password, 'full_name': fullName},
      );

      if (response.statusCode == 201 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          response.data as Map,
        );
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      } else {
        throw ServerException('Invalid status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ServerException(e.message);
    }
  }
}
