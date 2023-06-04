import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/post.dart';
import '../repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({required this.repository}) : super(PostsState()) {
    on<GetAllPosts>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      final count = event.count;

      try {
        final posts = await repository.getPosts();
        emit(
            state.copyWith(status: PostsStatus.success, posts: posts));
      } catch (error) {
        emit(state.copyWith(
            status: PostsStatus.error, error: error.toString()));
      }
    });


   on<AddPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      final title = event.title;
      final description = event.description;

      try {
        await repository.addPost(title, description);
        emit(state.copyWith(status: PostsStatus.added));
        emit(GetAllPosts(
            10) as PostsState); // Émet un événement GetAllPosts pour récupérer les posts à nouveau
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error));
      }
    });


    on<EditPost>((event, emit) async {
      emit(state.copyWith(status: PostsStatus.loading));

      final postId = event.id;
      final updatedTitle = event.updatedTitle;
      final updatedDescription = event.updatedDescription;

      try {
        await repository.editPost(postId, updatedTitle, updatedDescription);
        emit(state.copyWith(status: PostsStatus.updated));
        emit(GetAllPosts(10)
            as PostsState); // Émet un événement GetAllPosts pour récupérer les posts à nouveau
      } catch (error) {
        emit(state.copyWith(status: PostsStatus.error));
      }
    });
  }
}
