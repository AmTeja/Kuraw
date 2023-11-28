import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kuraw/core/data/model/user.dart';
import 'package:kuraw/core/data/repository/user_repository.dart';
import 'package:kuraw/features/auth/data/repositories/auth_repository.dart';
import 'package:kuraw/util/jwt.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepo authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown()) {
    on<_AuthStatusChanged>(_onAuthStatusChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    _subscription = _authenticationRepository.status.listen(
      (status) => add(_AuthStatusChanged(status)),
    );
  }

  final AuthRepo _authenticationRepository;
  final UserRepository _userRepository;
  late StreamSubscription<UserAuthenticationStatus> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case UserAuthenticationStatus.unknown:
        return emit(const AuthState.unknown());
      case UserAuthenticationStatus.signedIn:
        final user = await _tryGetUser();
        return user != null
            ? emit(AuthState.authenticated(user))
            : const AuthState.unauthenticated();
      case UserAuthenticationStatus.signedOut:
        return emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    _authenticationRepository.logOut();
  }

  Future<User?> _tryGetUser() async {
    try {
      final token = await _authenticationRepository.token;
      final user =
          await _userRepository.getUser(uuidFromJWT(token?.accessToken));
      return user;
    } catch (_) {
      return null;
    }
  }
}
