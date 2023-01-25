import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:book_app/features/auth/models/email.dart';
import 'package:book_app/features/auth/models/password.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>((event, emit) {
      final email = Email.dirty(event.email);
      emit(
        state.copyWith(
          email: email,
          status: Formz.validate([state.password, email]),
        ),
      );
    });

    on<LoginPasswordChanged>((event, emit) {
      final password = PasswordSecure.dirty(event.password);
      emit(
        state.copyWith(
          password: password,
          status: Formz.validate([state.email, password]),
        ),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      if (state.status.isValidated) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));
        try {
          await _authenticationRepository.login(
            state.email.value,
            state.password.value,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } on Exception catch (e) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, message: e.toString()));
        } catch (e) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              message: 'Terjadi kesalahan, coba lagi nanti.'));
        } finally {
          emit(state.copyWith(
              status: Formz.validate([state.email, state.password])));
        }
      }
    });
  }
}
