part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthenticationStatus status;

  const AuthState._({this.status = AuthenticationStatus.unknown});

  const AuthState.unknown() : this._();

  const AuthState.authenticated()
      : this._(status: AuthenticationStatus.authenticated);

  const AuthState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object> get props => [status];
}
