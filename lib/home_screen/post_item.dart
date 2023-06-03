import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  const PostItem({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(post.description),
      onTap: onTap,
    );
  }
}