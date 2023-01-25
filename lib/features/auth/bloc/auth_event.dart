part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthEvent {
  final AuthenticationStatus status;

  const AuthenticationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

class AuthenticationLogoutRequested extends AuthEvent {}
