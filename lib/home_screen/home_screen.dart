import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutterbase/home_screen/new_post.dart';
import 'package:tp_flutterbase/home_screen/post_bloc/post_bloc.dart';
import 'package:tp_flutterbase/home_screen/post_detail_screen.dart';
import 'package:tp_flutterbase/home_screen/repository/post_repository.dart';

import 'models/post.dart';
import 'post_bloc/post_bloc.dart';
import 'post_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des posts"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Gérer les erreurs
            return const Text('Une erreur s\'est produite.');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de chargement
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final posts = snapshot.data!.docs
                .map((doc) => Post.fromDocumentSnapshot(doc))
                .toList();

            if (posts.isEmpty) {
              // Aucun post disponible
              return const Center(child: Text('Aucun post disponible.'));
            }

            // Afficher la liste des posts
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostItem(
                  post: post,
                  onTap: () => _onPostTap(context, post),
                );
              },
            );
          }

          // Aucune donnée disponible
          return const Center(child: Text('Aucun post disponible.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showCustomModal(context),
      ),
    );
  }

  void _onPostTap(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  void showCustomModal(BuildContext context) {
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
              child: MyFormWidget(),
            ),
          ),
        );
      },
    );
  }
}
