import 'package:formz/formz.dart';

enum PostBodyValidityError { empty, tooLong }

class PostBody extends FormzInput<String, PostBodyValidityError> {
  const PostBody.pure() : super.pure('');
  const PostBody.dirty([String value = '']) : super.dirty(value);

  @override
  PostBodyValidityError? validator(String? value) {
    if (value?.isEmpty == true) {
      return PostBodyValidityError.empty;
    } else if (value!.length > 280) {
      return PostBodyValidityError.tooLong;
    }
    return null;
  }
}
