import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../models/email.dart';
import '../../models/name.dart';
import '../../models/password.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterNameChanged>((event, emit) {
      final name = Name.dirty(event.name);
      emit(state.copyWith(
        name: name,
        status: Formz.validate(
            [name, state.email, state.password, state.confirmPassword]),
      ));
    });

    on<RegisterEmailChanged>((event, emit) {
      final email = Email.dirty(event.email);
      emit(
        state.copyWith(
          email: email,
          status: Formz.validate(
              [state.name, email, state.password, state.confirmPassword]),
        ),
      );
    });

    on<RegisterPasswordChanged>((event, emit) {
      final password = PasswordSecure.dirty(event.password);
      emit(
        state.copyWith(
          password: password,
          status: Formz.validate(
              [state.name, state.email, password, state.confirmPassword]),
        ),
      );
    });

    on<RegisterConfirmPasswordChanged>((event, emit) {
      final password = PasswordSecure.dirty(event.password);
      emit(
        state.copyWith(
          confirmPassword: password,
          status: Formz.validate(
              [state.name, state.email, state.password, password]),
        ),
      );
    });

    on<RegisterRequested>((event, emit) async {
      if (state.status.isValidated) {
        emit(state.copyWith(status: FormzStatus.submissionInProgress));
        try {
          await _authenticationRepository.register(
            state.name.value,
            state.email.value,
            state.password.value,
          );
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } on Exception catch (e) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              registerErrorMessage: e.toString()));
        } catch (e) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              registerErrorMessage: 'Terjadi kesalahan yang tidak dikenal'));
        }
      }
    });
  }
}
