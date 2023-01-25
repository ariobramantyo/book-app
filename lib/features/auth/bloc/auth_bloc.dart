import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthState.unknown()) {
    on<AuthenticationStatusChanged>((event, emit) async {
      switch (event.status) {
        case AuthenticationStatus.authenticated:
          final user = await _getUserToken();
          emit(user != null
              ? const AuthState.authenticated()
              : const AuthState.unauthenticated());
          break;
        case AuthenticationStatus.unauthenticated:
          emit(const AuthState.unauthenticated());
          break;
        case AuthenticationStatus.unknown:
          emit(const AuthState.unknown());
          break;
      }
      notifyListeners();
    });

    on<AuthenticationLogoutRequested>((event, emit) {
      _authenticationRepository.logout();
    });

    _authenticationStatusSubscription = _authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<String?> _getUserToken() async {
    try {
      final token = await _authenticationRepository.getUserToken();
      return token;
    } catch (_) {
      return null;
    }
  }
}
