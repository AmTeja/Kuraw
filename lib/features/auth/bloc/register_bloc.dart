import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kuraw/features/auth/data/repositories/auth_repository.dart';

import '../data/model/models.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AuthRepo authenticationRepository,
  })  : _authRepo = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterProfilePicChanged>(_onProfilePicChanged);
    on<RegisterProfilePicSubmitted>(_onProfilePicSubmitted);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final AuthRepo _authRepo;

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        errorMessage: '',
        isValid: Formz.validate([
          state.email,
          state.password,
          username,
        ]),
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        errorMessage: '',
        isValid: Formz.validate([
          email,
          state.password,
          state.username,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        errorMessage: '',
        isValid: Formz.validate([
          state.email,
          password,
          state.username,
        ]),
      ),
    );
  }

  void _onProfilePicChanged(
    RegisterProfilePicChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        profilePic: event.profilePic,
      ),
    );
  }

  void _onProfilePicSubmitted(
    RegisterProfilePicSubmitted event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        previousProfilePic: state.profilePic,
      ),
    );
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.inProgress, errorMessage: null));
      try {
        await _authRepo.register(
          state.username.value,
          state.password.value,
          state.email.value,
          state.previousProfilePic ?? '',
        );
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            errorMessage: null,
          ),
        );
      } on AuthException catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ));
      }
    }
  }
}
