import 'package:formz/formz.dart';

enum PostValidityError { empty, tooLong, tooShort }

class PostTitle extends FormzInput<String, PostValidityError> {
  const PostTitle.pure() : super.pure('');
  const PostTitle.dirty([String value = '']) : super.dirty(value);

  @override
  PostValidityError? validator(String? value) {
    if (value?.isEmpty == true) {
      return PostValidityError.empty;
    } else if (value!.length > 100) {
      return PostValidityError.tooLong;
    } else if (value.length < 10) {
      return PostValidityError.tooShort;
    } else {
      return null;
    }
  }
}
