part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final FormzStatus status;
  final Name name;
  final Email email;
  final PasswordSecure password;
  final PasswordSecure confirmPassword;
  final String registerErrorMessage;

  const RegisterState({
    this.status = FormzStatus.pure,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const PasswordSecure.pure(),
    this.confirmPassword = const PasswordSecure.pure(),
    this.registerErrorMessage = '',
  });

  RegisterState copyWith({
    FormzStatus? status,
    Name? name,
    Email? email,
    PasswordSecure? password,
    PasswordSecure? confirmPassword,
    String? registerErrorMessage,
  }) {
    return RegisterState(
        status: status ?? this.status,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        registerErrorMessage:
            registerErrorMessage ?? this.registerErrorMessage);
  }

  @override
  List<Object?> get props =>
      [status, name, email, password, confirmPassword, registerErrorMessage];
}
