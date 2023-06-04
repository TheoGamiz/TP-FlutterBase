import 'package:cloud_firestore/cloud_firestore.dart';

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


  Future<void> addPost(String title, String description) async {
    try {
      final collection = FirebaseFirestore.instance.collection('posts');
      await collection.add({
        'title': title,
        'description': description,
      });
      print('Post added successfully');
    } catch (error) {
      print('Failed to add post: $error');
      rethrow;
    }
  }

  Future<void> editPost(
      String postId, String updatedTitle, String updatedDescription) async {
    try {
      final collection = FirebaseFirestore.instance.collection('posts');
      final postDoc = collection.doc(postId);
      await postDoc.update({
        'title': updatedTitle,
        'description': updatedDescription,
      });
      print('Post edited successfully');
    } catch (error) {
      print('Failed to edit post: $error');
      rethrow;
    }
  }
}
