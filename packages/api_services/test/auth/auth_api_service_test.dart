import 'package:api_services/api_services.dart';
import 'package:api_services/auth/model/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../fixtures/fixture_reader.dart';
import 'auth_api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late http.Client client;
  late AuthApiServiceImpl apiService;

  final loginUrl = '$baseUrl/api/login';
  final registerUrl = '$baseUrl/api/register';
  final logoutUrl = '$baseUrl/api/user/logout';

  final tName = 'mark';
  final tEmail = 'email@email.com';
  final tPassword = 'password';
  final tToken = 'token';

  setUp(
    () {
      client = MockClient();
      apiService = AuthApiServiceImpl(httpClient: client);
    },
  );

  group(
    'login',
    () {
      void setUpLoginRequestSuccess200() {
        when(client
            .post(Uri.parse(loginUrl),
                body: {'email': tEmail, 'password': tPassword})).thenAnswer(
            (_) async => http.Response(fixture('login_response.json'), 200));
      }

      test(
        'should perform a POST request when login',
        () async {
          setUpLoginRequestSuccess200();

          final _ = await apiService.login(tEmail, tPassword);

          verify(client.post(Uri.parse(loginUrl),
              body: {'email': tEmail, 'password': tPassword}));
        },
      );

      test(
        'should return login model when login request status code is 200 (success)',
        () async {
          setUpLoginRequestSuccess200();

          final result = await apiService.login(tEmail, tPassword);

          final expectedResult = Login(
              message: "User created",
              token: "6|v6TLNNdBjdHHLUqtw2aENki82b4cu4V10lz2yLee");

          expect(result, expectedResult);
        },
      );

      test(
        'should throw exception when login response status code 404 (failed)',
        () async {
          when(client.post(Uri.parse(loginUrl),
                  body: {'email': tEmail, 'password': tPassword}))
              .thenAnswer(
                  (_) async => http.Response(fixture('error.json'), 404));

          try {
            final _ = await apiService
                .login(tEmail, tPassword)
                .then((value) => fail('exception not thrown'));
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );

  group(
    'register',
    () {
      void setUpRegisterRequestSuccess200() {
        when(client.post(Uri.parse(registerUrl), body: {
          'name': tName,
          'email': tEmail,
          'password': tPassword,
          'password_confirmation': tPassword
        })).thenAnswer(
            (_) async => http.Response(fixture('register_response.json'), 200));
      }

      test(
        'should perform a POST request when register',
        () async {
          setUpRegisterRequestSuccess200();

          final _ = await apiService.register(tName, tEmail, tPassword);

          verify(client.post(Uri.parse(registerUrl), body: {
            'name': tName,
            'email': tEmail,
            'password': tPassword,
            'password_confirmation': tPassword
          }));
        },
      );

      test(
        'should throw exception when register response status code 404 (failed)',
        () async {
          when(client.post(Uri.parse(registerUrl), body: {
            'name': tName,
            'email': tEmail,
            'password': tPassword,
            'password_confirmation': tPassword
          })).thenAnswer(
              (_) async => http.Response(fixture('error.json'), 404));

          try {
            final _ = await apiService
                .register(tName, tEmail, tPassword)
                .then((value) => fail('exception not thrown'));
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );

  group(
    'logout',
    () {
      test(
        'should perform a DELETE request when logout',
        () async {
          when(client.delete(
            Uri.parse(logoutUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          )).thenAnswer((_) async => http.Response(fixture('error.json'), 200));

          final _ = await apiService.logout(tToken);

          verify(client.delete(
            Uri.parse(logoutUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          ));
        },
      );

      test(
        'should throw exception when logout response status code 404 (failed)',
        () async {
          when(client.delete(
            Uri.parse(logoutUrl),
            headers: {'Authorization': 'Bearer $tToken'},
          )).thenAnswer((_) async => http.Response(fixture('error.json'), 404));

          try {
            final _ = await apiService
                .logout(tToken)
                .then((value) => fail('exception not thrown'));
          } catch (e) {
            expect(e, isInstanceOf<Exception>());
          }
        },
      );
    },
  );
}
