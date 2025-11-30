import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/failures.dart';
import 'package:qualitysphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:qualitysphere/features/auth/domain/usecases/logout.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late Logout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Logout(mockAuthRepository);
  });

  test('should call repository.logout and return Right(void)', () async {
    // arrange
    when(
      () => mockAuthRepository.logout(),
    ).thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(null));
    verify(() => mockAuthRepository.logout());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when logout fails', () async {
    // arrange
    const failure = AuthFailure('Logout failed');

    when(
      () => mockAuthRepository.logout(),
    ).thenAnswer((_) async => const Left(failure));

    // act
    final result = await usecase();

    // assert
    expect(result, const Left(failure));
    verify(() => mockAuthRepository.logout());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
