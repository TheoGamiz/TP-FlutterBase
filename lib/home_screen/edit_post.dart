import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_bloc/post_bloc.dart';
import 'repository/post_repository.dart';

class MyEditFormWidget extends StatefulWidget {

  final String id;

  MyEditFormWidget({required this.id});

  @override
  _MyEditFormWidgetState createState() => _MyEditFormWidgetState();
}

class _MyEditFormWidgetState extends State<MyEditFormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PostsBloc(
      repository: RepositoryProvider.of<PostsRepository>(context),
    ); // Accès au PostsBloc

    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titre",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text("Description"),
            SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer une description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String title = _titleController.text;
                  String description = _descriptionController.text;

                  bloc.add(
                      EditPost( title, description, widget.id)); // Ajout du post via le bloc
                  _titleController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}
