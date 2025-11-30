import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:qualitysphere/features/auth/domain/usecases/get_current_user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetCurrentUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockAuthRepository);
  });

  const tUser = User(
    id: 'u1',
    email: 'user@example.com',
    fullName: 'Existing User',
    role: UserRole.user,
  );

  test('should return User when a session exists', () async {
    // arrange
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Right(null) when no user is logged in', () async {
    // arrange
    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when repository fails', () async {
    // arrange
    const failure = AuthFailure('Cache error');

    when(
      () => mockAuthRepository.getCurrentUser(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(failure));
    verify(() => mockAuthRepository.getCurrentUser());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
