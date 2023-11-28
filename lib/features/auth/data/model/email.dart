import 'package:formz/formz.dart';

enum EmailValidityError {
  empty,
  invalid,
}

class Email extends FormzInput<String, EmailValidityError> {
  const Email.pure() : super.pure('');
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidityError? validator(String? value) {
    if (value?.isEmpty == true) {
      return EmailValidityError.empty;
    } else if (value != null) {
      final regex = RegExp(
        r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
      );
      return regex.hasMatch(value) ? null : EmailValidityError.invalid;
    }
    return null;
  }
}
