import 'package:formz/formz.dart';

import '../../../core/util/string_validator.dart';

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');

  const Email.dirty([super.value = '']) : super.dirty();

  static String? getErrorText(EmailValidationError? errorType) {
    switch (errorType) {
      case EmailValidationError.empty:
        return 'E-mail tidak boleh kosong.';
      case EmailValidationError.invalid:
        return 'E-mail tidak valid.';
      default:
        return null;
    }
  }

  @override
  EmailValidationError? validator(String value) {
    if (!value.isValidEmail) {
      return EmailValidationError.invalid;
    } else if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return null;
  }
}
