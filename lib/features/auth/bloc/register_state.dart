part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.profilePic,
    this.isValid = false,
    this.errorMessage,
    this.previousProfilePic,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Email email;
  final Password password;
  final String? profilePic;
  final String? previousProfilePic;
  final bool isValid;
  final String? errorMessage;

  RegisterState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Email? email,
    Password? password,
    String? profilePic,
    String? previousProfilePic,
    bool? isValid,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePic: profilePic ?? this.profilePic,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      previousProfilePic: previousProfilePic ?? this.previousProfilePic,
    );
  }

  @override
  List<Object?> get props => [
        status,
        username,
        email,
        password,
        profilePic,
        isValid,
        errorMessage,
        previousProfilePic,
      ];
}
