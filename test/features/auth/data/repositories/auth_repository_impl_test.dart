import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';
import 'package:qualitysphere/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';

  const tUserModel = UserModel(
    id: 'u1',
    email: tEmail,
    fullName: 'Test User',
    role: UserRole.user,
  );
  final User tUserEntity = tUserModel.toEntity();

  group('login', () {
    test('should return User and cache it on success', () async {
      // arrange
      when(
        () => mockRemote.login(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => tUserModel);
      when(
        () => mockLocal.cacheUser(tUserModel),
      ).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.login(email: tEmail, password: tPassword);

      // assert
      expect(result, Right<Failure, User>(tUserEntity));
      verify(() => mockRemote.login(email: tEmail, password: tPassword));
      verify(() => mockLocal.cacheUser(tUserModel));
      verifyNoMoreInteractions(mockRemote);
      verifyNoMoreInteractions(mockLocal);
    });

    test(
      'should return ServerFailure when remote throws ServerException',
      () async {
        when(
          () => mockRemote.login(email: tEmail, password: tPassword),
        ).thenThrow(ServerException('Bad credentials'));

        final result = await repository.login(
          email: tEmail,
          password: tPassword,
        );

        expect(result, isA<Left<Failure, User>>());
        expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
        verify(() => mockRemote.login(email: tEmail, password: tPassword));
        verifyZeroInteractions(mockLocal);
      },
    );
  });

  group('getCurrentUser', () {
    test('should return User when cached user exists', () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, Right<Failure, User?>(tUserEntity));
      verify(() => mockLocal.getCachedUser());
      verifyNoMoreInteractions(mockLocal);
    });

    test('should return Right(null) when no cached user', () async {
      when(() => mockLocal.getCachedUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, const Right<Failure, User?>(null));
      verify(() => mockLocal.getCachedUser());
      verifyNoMoreInteractions(mockLocal);
    });
  });

  group('logout', () {
    test('should call clearUser and return Right(void)', () async {
      when(() => mockLocal.clearUser()).thenAnswer((_) async => Future.value());

      final result = await repository.logout();

      expect(result, const Right<Failure, void>(null));
      verify(() => mockLocal.clearUser());
      verifyNoMoreInteractions(mockLocal);
    });
  });
}
