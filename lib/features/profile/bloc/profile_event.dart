part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileFetch extends ProfileEvent {
  const ProfileFetch(this.uid);

  final String uid;

  @override
  List<Object> get props => [uid];
}

final class ProfileUpdate extends ProfileEvent {
  const ProfileUpdate({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}
