import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final UserModel user = await localDataSource.login(email, password);
      return user;
    } catch (e) {
      if (e is Exception) {
        throw AuthFailure(e.toString().replaceFirst('Exception: ', ''));
      } else {
        throw AuthFailure('Unexpected error');
      }
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await localDataSource.register(
        name,
        email,
        password,
      );
      return user;
    } catch (e) {
      if (e is Exception) {
        throw AuthFailure(e.toString().replaceFirst('Exception: ', ''));
      } else {
        throw AuthFailure('Unexpected error');
      }
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final UserModel? user = await localDataSource.getCurrentUser();
      return user;
    } catch (e) {
      if (e is Exception) {
        throw AuthFailure(e.toString().replaceFirst('Exception: ', ''));
      } else {
        throw AuthFailure('Unexpected error');
      }
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.logout();
    } catch (e) {
      if (e is Exception) {
        throw AuthFailure(e.toString().replaceFirst('Exception: ', ''));
      } else {
        throw AuthFailure('Unexpected error');
      }
    }
  }
}
