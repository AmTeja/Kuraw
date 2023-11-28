part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState._({
    this.status = UserAuthenticationStatus.unknown,
    this.user,
    this.token,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(User user, {String? token})
      : this._(
          status: UserAuthenticationStatus.signedIn,
          user: user,
          token: token,
        );

  const AuthState.unauthenticated()
      : this._(status: UserAuthenticationStatus.signedOut);

  final UserAuthenticationStatus status;
  final User? user;
  final String? token;

  @override
  List<Object?> get props => [status, user, token];
}
