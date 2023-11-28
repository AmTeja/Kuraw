import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kuraw/features/home/data/model/post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(PostInitial()) {
    on<PostEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
