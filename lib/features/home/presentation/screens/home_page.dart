import 'package:flutter/material.dart';
import 'package:kuraw/features/home/presentation/screens/post_create_page.dart';
import 'package:kuraw/features/home/presentation/widgets/posts_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuraw')),
      body: const PostsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(PostCreatePage.route());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
