import 'package:tp_flutterbase/home_screen/data_sources/posts_data_source.dart';

import '../models/post.dart';

class FireStorePostsDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(10, (index) {
      return Post(
        id: '$index',
        title: 'Titre $index',
        description: 'Description $index',
      );
    });
  }
}
