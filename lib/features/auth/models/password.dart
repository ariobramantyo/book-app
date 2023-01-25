import 'package:formz/formz.dart';

import '../../../core/util/string_validator.dart';

enum PasswordValidationError { empty, invalid, less }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (!value.isValidPassword) {
      return PasswordValidationError.invalid;
    } else if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    return null;
  }
}

class PasswordSecure extends FormzInput<String, PasswordValidationError> {
  const PasswordSecure.pure() : super.pure('');

  const PasswordSecure.dirty([super.value = '']) : super.dirty();

  static String? getErrorText(PasswordValidationError? errorType) {
    switch (errorType) {
      case PasswordValidationError.empty:
        return 'Password tidak boleh kosong.';
      case PasswordValidationError.less:
        return 'Password tidak boleh kurang dari 8 karakter.';
      default:
        return null;
    }
  }

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.less;
    }
    return null;
  }
}
