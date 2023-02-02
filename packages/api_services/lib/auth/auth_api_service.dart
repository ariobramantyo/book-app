import 'dart:convert';
import 'package:api_services/auth/model/login.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

const String baseUrl = 'https://basic-book-crud-e3u54evafq-et.a.run.app';

abstract class AuthApiService {
  Future<Login> login(String email, String password);

  Future<void> register(String name, String email, String password);

  Future<void> logout(String token);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Login> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/login');

    final loginResponse =
        await http.post(url, body: {'email': email, 'password': password});

    if (loginResponse.statusCode != 200) {
      throw Exception(jsonDecode(loginResponse.body)['message']);
    }

    return Login.fromJson(jsonDecode(loginResponse.body));
  }

  @override
  Future<void> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/register');

    final registerResponse = await http.post(
      url,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password
      },
    );

    if (registerResponse.statusCode != 200) {
      throw Exception(jsonDecode(registerResponse.body)['message']);
    }
  }

  @override
  Future<void> logout(String token) async {
    final url = Uri.parse('$baseUrl/api/user/logout');

    final looutResponse = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (looutResponse.statusCode != 200) {
      throw Exception(jsonDecode(looutResponse.body)['message']);
    }
  }
}
