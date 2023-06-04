part of 'post_bloc.dart';

@immutable
abstract class PostsEvent {}

class GetAllPosts extends PostsEvent {
  final int count;
  GetAllPosts(this.count);
}

class AddPost extends PostsEvent {
  final String title;
  final String description;
  AddPost(this.title, this.description);
}

class EditPost extends PostsEvent {
  final String id;
  final String updatedTitle;
  final String updatedDescription;
  EditPost(this.updatedTitle, this.updatedDescription, this.id);
}
