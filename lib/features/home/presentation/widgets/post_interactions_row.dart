import 'package:flutter/material.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/core/util/helper_functions.dart';
import 'package:kuraw/features/home/data/model/post.dart';

class PostInteractionsRow extends StatelessWidget {
  const PostInteractionsRow(this.post, {super.key});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onBackground;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Posted ${agoFromDateTime(post.createdAt)}",
            style: context.textTheme.labelSmall,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.share_outlined, color: iconColor),
            onPressed: () {},
            iconSize: 14,
          ),
          IconButton(
            icon: Icon(Icons.comment_outlined, color: iconColor),
            onPressed: () {},
            iconSize: 14,
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: iconColor),
            onPressed: () {},
            iconSize: 14,
          ),
        ],
      ),
    );
  }
}
