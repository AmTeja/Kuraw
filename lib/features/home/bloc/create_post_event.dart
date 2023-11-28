part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

final class CreatePostTitleChanged extends CreatePostEvent {
  const CreatePostTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class CreatePostBodyChanged extends CreatePostEvent {
  const CreatePostBodyChanged(this.body);

  final String body;

  @override
  List<Object> get props => [body];
}

final class CreatePostImageChanged extends CreatePostEvent {
  const CreatePostImageChanged(this.image);

  final String image;

  @override
  List<Object> get props => [image];
}

final class CreatePostImageSubmitted extends CreatePostEvent {
  const CreatePostImageSubmitted();
}

final class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
