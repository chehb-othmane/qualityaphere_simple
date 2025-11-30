import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  const baseUrl = 'https://api.qualitysphere.dev';

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(client: mockDio, baseUrl: baseUrl);
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';
  const tFullName = 'Test User';

  const tUserModel = UserModel(
    id: 'u1',
    email: tEmail,
    fullName: tFullName,
    role: UserRole.user,
  );

  final tUserJson = {
    'id': 'u1',
    'email': tEmail,
    'full_name': tFullName,
    'role': 'USER',
    'created_at': null,
  };

  group('login', () {
    test('should return UserModel when the status code is 200', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {'user': tUserJson},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await dataSource.login(email: tEmail, password: tPassword);

      // assert
      expect(result, tUserModel);
      verify(
        () => mockDio.post(
          '$baseUrl/auth/login',
          data: {'email': tEmail, 'password': tPassword},
        ),
      );
      verifyNoMoreInteractions(mockDio);
    });

    test('should throw ServerException on non-200 response', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final call = dataSource.login;

      // assert
      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => mockDio.post(
          '$baseUrl/auth/login',
          data: {'email': tEmail, 'password': tPassword},
        ),
      );
      verifyNoMoreInteractions(mockDio);
    });
  });

  group('register', () {
    test('should return UserModel when the status code is 201', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {'user': tUserJson},
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await dataSource.register(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      );

      // assert
      expect(result, tUserModel);
      verify(
        () => mockDio.post(
          '$baseUrl/auth/register',
          data: {
            'email': tEmail,
            'password': tPassword,
            'full_name': tFullName,
          },
        ),
      );
      verifyNoMoreInteractions(mockDio);
    });

    test('should throw ServerException on non-201 response', () async {
      // arrange
      when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
        (_) async => Response(
          data: {},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final call = dataSource.register;

      // assert
      expect(
        () => call(email: tEmail, password: tPassword, fullName: tFullName),
        throwsA(isA<ServerException>()),
      );
      verify(
        () => mockDio.post(
          '$baseUrl/auth/register',
          data: {
            'email': tEmail,
            'password': tPassword,
            'full_name': tFullName,
          },
        ),
      );
      verifyNoMoreInteractions(mockDio);
    });
  });
}
