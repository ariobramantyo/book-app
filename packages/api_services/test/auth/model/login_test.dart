import 'dart:convert';

import 'package:api_services/auth/model/login.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group(
    'login model',
    () {
      final tLoginModel = Login(
          message: 'User created',
          token: '6|v6TLNNdBjdHHLUqtw2aENki82b4cu4V10lz2yLee');

      test(
        'should return a valid model from JSON map',
        () {
          final result =
              Login.fromJson(jsonDecode(fixture('login_response.json')));

          final expectedModel = tLoginModel;

          expect(result, expectedModel);
        },
      );

      test(
        'should return json from login model',
        () {
          final result = tLoginModel.toJson();

          final expectedJson = jsonDecode(fixture('login_response.json'));

          expect(result, expectedJson);
        },
      );

      test(
        'should return login model with null properties from json with null for each key',
        () {
          final result = Login.fromJson({'message': null, 'token': null});

          final expectedModel = Login();

          expect(result, expectedModel);
        },
      );

      test(
        'should return a proper json from login model that null for each properties',
        () {
          final result = Login().toJson();

          final expectedJson = {'message': null, 'token': null};

          expect(result, expectedJson);
        },
      );
    },
  );
}
