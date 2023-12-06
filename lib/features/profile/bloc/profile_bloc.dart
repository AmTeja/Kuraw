import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kuraw/core/data/model/user.dart';
import 'package:kuraw/features/profile/data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required ProfileRepository profileRepository})
      : _repository = profileRepository,
        super(ProfileInitial()) {
    on<ProfileFetch>(_onProfileFetch);
    on<ProfileUpdate>(_onProfileUpdate);
  }

  final ProfileRepository _repository;

  Future<void> _onProfileFetch(
    ProfileFetch event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _repository.getUser(event.uid);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onProfileUpdate(
    ProfileUpdate event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // final user = await _repository.updateUser(event.user);
      // emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
