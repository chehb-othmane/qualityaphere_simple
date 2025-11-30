import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qualitysphere/core/errors/exceptions.dart';
import 'package:qualitysphere/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:qualitysphere/features/auth/data/models/user_model.dart';
import 'package:qualitysphere/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl(prefs: mockPrefs);
  });

  const tUserModel = UserModel(
    id: 'u1',
    email: 'user@example.com',
    fullName: 'Test User',
    role: UserRole.user,
  );

  final tUserJsonString = json.encode(tUserModel.toJson());

  group('getCachedUser', () {
    test('should return UserModel when there is cached data', () async {
      // arrange
      when(
        () => mockPrefs.getString(cachedUserKey),
      ).thenReturn(tUserJsonString);

      // act
      final result = await dataSource.getCachedUser();

      // assert
      expect(result, tUserModel);
      verify(() => mockPrefs.getString(cachedUserKey));
    });

    test('should return null when there is no cached data', () async {
      when(() => mockPrefs.getString(cachedUserKey)).thenReturn(null);

      final result = await dataSource.getCachedUser();

      expect(result, isNull);
      verify(() => mockPrefs.getString(cachedUserKey));
    });
  });

  group('cacheUser', () {
    test('should call SharedPreferences.setString', () async {
      when(
        () => mockPrefs.setString(cachedUserKey, any()),
      ).thenAnswer((_) async => true);

      await dataSource.cacheUser(tUserModel);

      verify(() => mockPrefs.setString(cachedUserKey, tUserJsonString));
    });

    test('should throw CacheException when setString fails', () async {
      when(
        () => mockPrefs.setString(cachedUserKey, any()),
      ).thenAnswer((_) async => false);

      expect(
        () => dataSource.cacheUser(tUserModel),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
