  import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kuraw/features/auth/data/model/models.dart';
import 'package:kuraw/features/auth/data/repositories/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepo authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthRepo _authenticationRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        errorMessage: '',
        isValid: Formz.validate([
          state.password,
          username,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        errorMessage: '',
        isValid: Formz.validate([password, state.username]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.login(
          state.username.value,
          state.password.value,
        );
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            errorMessage: null,
          ),
        );
      } on AuthException catch (e) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(
            status: FormzSubmissionStatus.failure, errorMessage: e.toString()));
      }
    }
  }
}
