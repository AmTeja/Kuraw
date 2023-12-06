import 'package:flutter/material.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/core/widgets/cached_image.dart';
import 'package:kuraw/features/home/data/model/post.dart';
import 'package:kuraw/features/home/presentation/widgets/post_interactions_row.dart';
import 'package:kuraw/features/home/presentation/widgets/post_options.dart';
import 'package:kuraw/features/profile/presentation/screens/profile_screen.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: GestureDetector(
            onTap: () {
              context.push(ProfilePage.route(post.user!.id));
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(post.user!.profilePicture),
            ),
          ),
          title: Text(post.user!.username, style: textTheme.titleMedium),
          trailing: PostOptions(post),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  post.content,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        if (post.image.isNotEmpty) CachedImage(post.image),
        PostInteractionsRow(post),
      ],
    );
  }
}
