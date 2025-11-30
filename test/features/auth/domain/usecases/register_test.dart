import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:qualitysphere/features/auth/domain/usecases/register.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Register usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Register(mockAuthRepository);
  });

  const tEmail = 'newuser@example.com';
  const tPassword = 'password123';
  const tFullName = 'New User';

  const tUser = User(
    id: 'u2',
    email: tEmail,
    fullName: tFullName,
    role: UserRole.user, // par défaut user
  );

  test('should return User with role User when register succeeds', () async {
    // arrange
    when(
      () => mockAuthRepository.register(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    ).thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
      const RegisterParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    // assert
    expect(result, const Right(tUser));
    expect(tUser.role, UserRole.user); // تأكيد أن role = user
    verify(
      () => mockAuthRepository.register(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when register fails', () async {
    // arrange
    const failure = AuthFailure('Email already used');

    when(
      () => mockAuthRepository.register(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase(
      const RegisterParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    // assert
    expect(result, const Left(failure));
    verify(
      () => mockAuthRepository.register(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
