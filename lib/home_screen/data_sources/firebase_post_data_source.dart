import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp_flutterbase/home_screen/data_sources/posts_data_source.dart';

import '../models/post.dart';

class FireStorePostsDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    List<Post> posts = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      Post post = Post(
        id: doc.id,
        title: data?['title'],
        description: data?['description'],
      );
      posts.add(post);
    });

    return posts;
  }
}
