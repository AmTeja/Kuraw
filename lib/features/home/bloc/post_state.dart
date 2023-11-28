part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostLoaded extends PostState {
  const PostLoaded(this.post);

  final Post post;

  @override
  List<Object> get props => [post];
}

final class PostError extends PostState {
  const PostError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

final class PostDoesntExist extends PostState {}
