part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

final class PostLiked extends PostEvent {}

final class PostUnliked extends PostEvent {}

final class PostDeleted extends PostEvent {}

final class PostCommented extends PostEvent {
  const PostCommented(this.comment);

  final String comment;

  @override
  List<Object> get props => [comment];
}
