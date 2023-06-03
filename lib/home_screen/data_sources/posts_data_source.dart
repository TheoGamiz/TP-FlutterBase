import '../models/post.dart';

abstract class PostsDataSource {
  Future<List<Post>> getPosts();
}
