import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyFormWidget extends StatefulWidget {
  @override
  _MyFormWidgetState createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
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
                  // Validation du formulaire réussie, vous pouvez traiter les données ici
                  String title = _titleController.text;
                  String description = _descriptionController.text;

                  // Exemple de traitement des données
                  _submitForm(title, description);
                }
              },
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(String title, String description) {
    // Exemple de traitement du formulaire
    print('Titre : $title');
    print('Description : $description');
    _addPost(title, description);

    // Réinitialiser les champs du formulaire
    _titleController.clear();
    _descriptionController.clear();

    // Fermer la page modale ou effectuer une autre action
    Navigator.of(context).pop();
  }

  Future<void> _addPost(String title, String description) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('posts');

    try {
      await usersCollection.add({"title": title, "description": description});
      print("User added");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }
}
