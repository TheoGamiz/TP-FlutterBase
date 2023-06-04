import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.title,
    required this.description,
  });


  factory Post.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Post(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

}
