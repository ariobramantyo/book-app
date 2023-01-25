part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final Email email;
  final PasswordSecure password;
  final String? message;

  const LoginState(
      {this.status = FormzStatus.pure,
      this.email = const Email.pure(),
      this.password = const PasswordSecure.pure(),
      this.message});

  LoginState copyWith(
      {FormzStatus? status,
      Email? email,
      PasswordSecure? password,
      String? message}) {
    return LoginState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        message: message ?? this.message);
  }

  @override
  List<Object?> get props => [status, email, password, message];
}
