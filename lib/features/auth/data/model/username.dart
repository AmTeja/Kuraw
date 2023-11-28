import 'package:formz/formz.dart';

enum UsernameValidityError { empty }

class Username extends FormzInput<String, UsernameValidityError> {
  const Username.pure() : super.pure('');
  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidityError? validator(String? value) {
    return value?.isNotEmpty == true ? null : UsernameValidityError.empty;
  }
}
