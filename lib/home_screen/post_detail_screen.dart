import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'edit_post.dart';
import 'models/post.dart';
import 'new_post.dart';

class PostDetailScreen extends StatelessWidget {
  static const String routeName = '/PostDetailScreen';

  static void navigateTo(BuildContext context, Post post) {
    Navigator.of(context).pushNamed(routeName, arguments: post);
  }

  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(post.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Post not found');
            }

            final updatedPost = Post.fromDocumentSnapshot(snapshot.data!);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(updatedPost.title),
                Text(updatedPost.description),
                Text(updatedPost.id),
                const Spacer(),
                Row(
                  children: [
                    Spacer(),
                    FloatingActionButton(
                      child: const Icon(Icons.edit),
                      onPressed: () => showCustomModal(context, updatedPost.id),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }




  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
 
}


void showCustomModal(BuildContext context, String id) {
  double screenHeight = MediaQuery.of(context).size.height;
  double modalHeight = screenHeight * 0.75;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: modalHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: MyEditFormWidget(id: id,),
          ),
        ),
      );
    },
  );
}
