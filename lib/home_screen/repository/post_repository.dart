import '../data_sources/posts_data_source.dart';
import '../models/post.dart';

class PostsRepository {
  final PostsDataSource remoteDataSource;

  PostsRepository({
    required this.remoteDataSource,
  });

  Future<List<Post>> getPosts() async {
    try {
      final posts = await remoteDataSource.getPosts();
      return posts;
    } catch (e) {
      rethrow;
    }
  }
}
