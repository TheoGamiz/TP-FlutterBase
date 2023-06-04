// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp_flutterbase/home_screen/data_sources/posts_data_source.dart';
import 'package:tp_flutterbase/home_screen/models/post.dart';
import 'package:tp_flutterbase/home_screen/repository/post_repository.dart';

import 'package:tp_flutterbase/main.dart';




class EmptyRemoteDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }
}

class FailingRemoteDataSource extends PostsDataSource {
  @override
  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('Error');
  }
}

void main() {
  testWidgets('Posts Screen with succee', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          remoteDataSource: EmptyRemoteDataSource(),
        ),
        
      ),
    );

    await tester.pump();

    expect(find.text('Posts'), findsOneWidget);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Aucun post'), findsOneWidget);
  });

  testWidgets('Posts Screen with error', (WidgetTester tester) async {
    await tester.pumpWidget(
      RepositoryProvider(
        create: (context) => PostsRepository(
          remoteDataSource: FailingRemoteDataSource(),
        ),
        
      ),
    );

    await tester.pump();

    expect(find.text('Posts'), findsOneWidget);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text(Exception('Error').toString()), findsOneWidget);
  });
}
