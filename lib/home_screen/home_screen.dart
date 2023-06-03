import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp_flutterbase/home_screen/new_post.dart';
import 'package:tp_flutterbase/home_screen/post_bloc/post_bloc.dart';
import 'package:tp_flutterbase/home_screen/post_detail_screen.dart';
import 'package:tp_flutterbase/home_screen/repository/post_repository.dart';

import 'models/post.dart';
import 'post_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsBloc(repository:  RepositoryProvider.of<PostsRepository>(context),
      )..add(GetAllPosts(10)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Liste des posts"),
        ),
        body: BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostsStatus.initial:
                    return const SizedBox();
                  case PostsStatus.loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case PostsStatus.error:
                    return Center(
                      child: Text(state.error),
                    );
                  case PostsStatus.success:
                    final posts = state.posts;

                    if (posts.isEmpty) {
                      return const Center(
                        child: Text('Aucun produit'),
                      );
                    }

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
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => showCustomModal(context),
            ),
          )
    );
  }



  void _onRefreshList(BuildContext context) {
    final postsBloc = BlocProvider.of<PostsBloc>(context);
    postsBloc.add(GetAllPosts(10));
  }

  void _onPostTap(BuildContext context, Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post,)),
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
      
