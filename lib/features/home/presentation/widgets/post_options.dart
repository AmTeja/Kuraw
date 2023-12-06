import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuraw/features/auth/bloc/auth_bloc.dart';
import 'package:kuraw/features/home/data/model/post.dart';

class PostOptions extends StatelessWidget {
  const PostOptions(this.post, {super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              if (post.user!.id == state.user?.id) ...[
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ] else ...[
                const PopupMenuItem(
                  value: 'report',
                  child: Text('Report'),
                ),
              ]
            ];
          },
        );
      },
    );
  }
}
