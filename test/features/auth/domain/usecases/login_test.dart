import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:qualitysphere/features/auth/domain/usecases/login.dart';

/// Mock simple du AuthRepository en utilisant mocktail
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Login usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Login(mockAuthRepository);
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';

  const tUser = User(
    id: 'u1',
    email: tEmail,
    fullName: 'Test User',
    role: UserRole.user, // par défaut User
  );

  test('should return User when login succeeds', () async {
    // arrange
    when(
      () => mockAuthRepository.login(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
      const LoginParams(email: tEmail, password: tPassword),
    );

    // assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when login fails', () async {
    // arrange
    const failure = AuthFailure('Invalid credentials');

    when(
      () => mockAuthRepository.login(email: tEmail, password: tPassword),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(
      const LoginParams(email: tEmail, password: tPassword),
    );

    // assert
    expect(result, const Left(failure));
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
