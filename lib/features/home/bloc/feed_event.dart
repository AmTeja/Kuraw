part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedFetched extends FeedEvent {
  const FeedFetched();
}

class FeedRefreshRequested extends FeedEvent {
  const FeedRefreshRequested();
}

class FeedPostAdded extends FeedEvent {
  const FeedPostAdded(this.post);

  final Post post;

  @override
  List<Object> get props => [post];
}
