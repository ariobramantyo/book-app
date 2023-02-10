import 'package:api_services/api_services.dart';
import 'package:api_services/auth/model/login.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_repository_test.mocks.dart';

@GenerateMocks([AuthApiService, FlutterSecureStorage])
void main() {
  late MockAuthApiService authApiService;
  late MockFlutterSecureStorage flutterSecureStorage;
  late AuthenticationRepositoryImpl repository;

  const tToken = 'token';
  const tEmail = 'email@gmail.com';
  const tPassword = '12345678';
  const tName = 'mark';

  setUp(
    () async {
      authApiService = MockAuthApiService();
      flutterSecureStorage = MockFlutterSecureStorage();
      repository = AuthenticationRepositoryImpl.internal(
          authApiService: authApiService,
          flutterSecureStorage: flutterSecureStorage);
    },
  );

  group(
    'getUserToken',
    () {
      test(
        'should return token type string when there is a token in local storage',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);

          final result = await repository.getUserToken();

          verify(flutterSecureStorage.read(key: 'TOKEN'));
          expect(result, tToken);
        },
      );

      test(
        'should return null when there is no token in local storage',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => null);

          final result = await repository.getUserToken();

          verify(flutterSecureStorage.read(key: 'TOKEN'));
          expect(result, null);
        },
      );
    },
  );

  group(
    'login',
    () {
      final tLogin = Login(token: tToken);
      test(
        'should save token to local storage when login is success',
        () async {
          when(authApiService.login(tEmail, tPassword))
              .thenAnswer((_) async => tLogin);
          when(flutterSecureStorage.write(key: 'TOKEN', value: tToken))
              .thenAnswer((_) async {});

          await repository.login(tEmail, tPassword);

          verify(flutterSecureStorage.write(key: 'TOKEN', value: tToken));
        },
      );

      test(
        'should not save token to local storage when login is failed',
        () async {
          when(authApiService.login(tEmail, tPassword)).thenThrow(Exception);

          try {
            await repository.login(tEmail, tPassword);
          } catch (_) {}
          verifyNever(flutterSecureStorage.write(key: 'TOKEN', value: tToken));
        },
      );

      test(
        'should call login api service when login is invoked',
        () async {
          when(authApiService.login(tEmail, tPassword))
              .thenAnswer((_) async => tLogin);
          when(flutterSecureStorage.write(key: 'TOKEN', value: tToken))
              .thenAnswer((_) async {});

          await repository.login(tEmail, tPassword);

          verify(authApiService.login(tEmail, tPassword));
        },
      );

      test(
        'should throw Exception when login is failed',
        () {
          when(authApiService.login(tEmail, tPassword)).thenThrow(Exception);

          expect(() async => repository.login(tEmail, tPassword),
              throwsA(Exception));
        },
      );
    },
  );

  group(
    'register',
    () {
      test(
        'should call authApiService when call repository register',
        () async {
          when(authApiService.register(tName, tEmail, tPassword))
              .thenAnswer((_) async => () {});

          await repository.register(tName, tEmail, tPassword);

          verify(authApiService.register(tName, tEmail, tPassword));
        },
      );

      test(
        'should throw exception when register failed',
        () {
          when(authApiService.register(tName, tEmail, tPassword))
              .thenThrow(Exception);

          expect(
              () async => await repository.register(tName, tEmail, tPassword),
              throwsA(Exception));
        },
      );
    },
  );

  group(
    'logout',
    () {
      test(
        'should delete token from local storage when logout is success',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);
          when(authApiService.logout(tToken)).thenAnswer((_) async => () {});
          when(flutterSecureStorage.delete(key: 'TOKEN'))
              .thenAnswer((_) async => () {});

          await repository.logout();

          verify(authApiService.logout(tToken));
          verify(flutterSecureStorage.delete(key: 'TOKEN'));
        },
      );

      test(
        'should throw exception when logout is failed',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);
          when(authApiService.logout(tToken)).thenThrow(Exception);

          expect(() async => repository.logout(), throwsA(Exception));
          verify(flutterSecureStorage.read(key: 'TOKEN'));
        },
      );

      test(
        'should not delete token from local storage if log out failed',
        () async {
          when(flutterSecureStorage.read(key: 'TOKEN'))
              .thenAnswer((_) async => tToken);
          when(authApiService.logout(tToken)).thenThrow(Exception);

          try {
            await repository.logout();
          } catch (_) {}

          verifyNever(flutterSecureStorage.delete(key: 'TOKEN'));
        },
      );
    },
  );
}
