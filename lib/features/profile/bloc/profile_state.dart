part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

final class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
