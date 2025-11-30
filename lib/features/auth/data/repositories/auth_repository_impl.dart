import 'package:dartz/dartz.dart';

import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserModel userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache localement la session
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final UserModel userModel = await remoteDataSource.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      // User nouvellement créé: role devrait être UserRole.user
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      if (userModel == null) {
        return const Right(null);
      }
      return Right(userModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
