import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:kuraw/features/home/bloc/feed_bloc.dart';
import 'package:kuraw/features/home/data/dto/post_dto.dart';
import 'package:kuraw/features/home/data/model/post.dart';
import 'package:kuraw/features/home/data/model/post_body.dart';
import 'package:kuraw/features/home/data/model/post_title.dart';
import 'package:kuraw/features/home/data/repository/post_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc({
    required PostRepository postRepo, required FeedBloc feedBloc,
  })  : _postRepo = postRepo,
        _feedBloc = feedBloc,
        super(const CreatePostState()) {
    on<CreatePostTitleChanged>(_onTitleChanged);
    on<CreatePostBodyChanged>(_onBodyChanged);
    on<CreatePostImageChanged>(_onImageChanged);
    on<CreatePostImageSubmitted>(_onImageSubmitted);
    on<CreatePostSubmitted>(_onSubmitted);
  }

  final PostRepository _postRepo;
  final FeedBloc _feedBloc;

  void _onTitleChanged(
    CreatePostTitleChanged event,
    Emitter<CreatePostState> emit,
  ) {
    final title = PostTitle.dirty(event.title);
    emit(
      state.copyWith(
        title: title,
        errorMessage: '',
        isValid: Formz.validate([state.body, title]),
      ),
    );
  }

  void _onBodyChanged(
    CreatePostBodyChanged event,
    Emitter<CreatePostState> emit,
  ) {
    final body = PostBody.dirty(event.body);
    emit(
      state.copyWith(
        body: body,
        errorMessage: '',
        isValid: Formz.validate([body, state.title]),
      ),
    );
  }

  void _onImageChanged(
    CreatePostImageChanged event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        image: event.image,
      ),
    );
  }

  void _onImageSubmitted(
    CreatePostImageSubmitted event,
    Emitter<CreatePostState> emit,
  ) {
    emit(
      state.copyWith(
        previousImage: state.image,
        image: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        final postDTO = PostDTO(
          title: state.title.value,
          content: state.body.value,
          image: state.previousImage ?? '',
        );
        final post = await _postRepo.createPost(postDTO, event.userId);
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            post: post,
            errorMessage: null,
          ),
        );
        _feedBloc.add(FeedPostAdded(post));
      } catch (e) {
        emit(state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }
}
