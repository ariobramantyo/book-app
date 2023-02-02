import 'dart:async';

import 'package:api_services/api_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract class AuthenticationRepository {
  Stream<AuthenticationStatus> get status;
  Future<String?> getUserToken();
  Future<void> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
  void dispose();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final AuthApiService _authApiService;
  final FlutterSecureStorage _flutterSecureStorage;

  static final AuthenticationRepositoryImpl _instance =
      AuthenticationRepositoryImpl._internal();

  factory AuthenticationRepositoryImpl() => _instance;

  AuthenticationRepositoryImpl._internal(
      {AuthApiService? authApiService,
      FlutterSecureStorage? flutterSecureStorage})
      : _authApiService = authApiService ?? AuthApiService(),
        _flutterSecureStorage =
            flutterSecureStorage ?? const FlutterSecureStorage();

  @override
  Stream<AuthenticationStatus> get status async* {
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    if (token != null) {
      yield AuthenticationStatus.authenticated;
    } else {
      yield AuthenticationStatus.unauthenticated;
    }

    yield* _controller.stream;
  }

  @override
  Future<String?> getUserToken() async {
    final token = await _flutterSecureStorage.read(key: 'TOKEN');

    if (token != null) {
      return token;
    }

    return null;
  }

  @override
  Future<void> login(String email, String password) async {
    final result = await _authApiService.login(email, password);
    await _flutterSecureStorage.write(key: 'TOKEN', value: result.token);
    _controller.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await _authApiService.register(name, email, password);
  }

  @override
  Future<void> logout() async {
    final token = await _flutterSecureStorage.read(key: 'TOKEN');
    await _authApiService.logout(token!);

    await _flutterSecureStorage.delete(key: 'TOKEN');
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  @override
  void dispose() => _controller.close();
}
