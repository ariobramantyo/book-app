import 'package:formz/formz.dart';

enum NameValidationError { empty }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');

  const Name.dirty([super.value = '']) : super.dirty();

  static String? getErrorText(NameValidationError? errorType) {
    switch (errorType) {
      case NameValidationError.empty:
        return 'Nama tidak boleh kosong.';
      default:
        return null;
    }
  }

  @override
  NameValidationError? validator(String value) {
    if (value.isEmpty) {
      return NameValidationError.empty;
    }
    return null;
  }
}
