import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:kuraw/features/home/data/model/post.dart';
import 'package:kuraw/features/home/data/repository/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'feed_event.dart';
part 'feed_state.dart';

const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(const FeedState()) {
    on<FeedFetched>(
      _onFeedFeteched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FeedRefreshRequested>(
      _onFeedRefreshRequested,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FeedPostAdded>(
      _onFeedPostAdded,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final PostRepository _postRepository;

  Future<void> _onFeedFeteched(
    FeedFetched event,
    Emitter<FeedState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == FeedStatus.initial) {
        final posts = await _postRepository.fetchPosts();
        return emit(state.copyWith(
          status: FeedStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }

      final posts = await _postRepository.fetchPosts(state.posts.length);
      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: FeedStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (_) {
      emit(state.copyWith(status: FeedStatus.failure));
    }
  }

  Future<void> _onFeedRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final posts = await _postRepository.fetchPosts();
      emit(state.copyWith(
        status: FeedStatus.success,
        posts: posts,
        hasReachedMax: false,
      ));
    } catch (_) {
      emit(state.copyWith(status: FeedStatus.failure));
    }
  }

  void _onFeedPostAdded(
    FeedPostAdded event,
    Emitter<FeedState> emit,
  ) {
    emit(state.copyWith(
      posts: [event.post, ...state.posts],
    ));
  }
}
