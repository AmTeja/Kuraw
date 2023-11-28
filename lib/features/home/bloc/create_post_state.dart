part of 'create_post_bloc.dart';

class CreatePostState extends Equatable {
  const CreatePostState({
    this.status = FormzSubmissionStatus.initial,
    this.title = const PostTitle.pure(),
    this.body = const PostBody.pure(),
    this.image,
    this.previousImage,
    this.isValid = false,
    this.errorMessage,
    this.post,
  });

  final FormzSubmissionStatus status;
  final PostTitle title;
  final PostBody body;
  final String? image;
  final String? previousImage;
  final bool isValid;
  final String? errorMessage;
  final Post? post;

  CreatePostState copyWith({
    FormzSubmissionStatus? status,
    PostTitle? title,
    PostBody? body,
    String? image,
    String? previousImage,
    bool? isValid,
    String? errorMessage,
    Post? post,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      previousImage: previousImage ?? this.previousImage,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      post: post ?? this.post,
    );
  }

  @override
  List<Object?> get props =>
      [status, title, body, isValid, errorMessage, image, previousImage, post];
}
