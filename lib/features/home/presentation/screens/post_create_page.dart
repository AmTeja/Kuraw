import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/core/widgets/cached_image.dart';
import 'package:kuraw/core/widgets/responsive_textfield.dart';
import 'package:kuraw/features/auth/bloc/auth_bloc.dart';
import 'package:kuraw/features/home/bloc/create_post_bloc.dart';
import 'package:kuraw/features/home/bloc/feed_bloc.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const PostCreatePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider(
        create: (context) => CreatePostBloc(
          postRepo: RepositoryProvider.of(context),
          feedBloc: context.read<FeedBloc>(),
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
          ),
          body: const CreatePostForm(),
        ),
      ),
    );
  }
}

class CreatePostForm extends StatelessWidget {
  const CreatePostForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: context.width,
        child: Column(
          children: [
            BlocBuilder<CreatePostBloc, CreatePostState>(
              builder: (context, state) {
                return RTextField(
                  onChanged: (value) => context
                      .read<CreatePostBloc>()
                      .add(CreatePostTitleChanged(value)),
                  hintText: 'Give your post a catchy title',
                  maxLines: 3,
                  maxLength: 120,
                );
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<CreatePostBloc, CreatePostState>(
              builder: (context, state) {
                return RTextField(
                  onChanged: (value) => context
                      .read<CreatePostBloc>()
                      .add(CreatePostBodyChanged(value)),
                  hintText: 'Tell us more about your post',
                  maxLines: 10,
                  maxLength: 500,
                );
              },
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(context.rWidth, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RTextField(
                            onChanged: (profilePic) => context
                                .read<CreatePostBloc>()
                                .add(CreatePostImageChanged(profilePic)),
                            hintText: 'Profile Picture URL',
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<CreatePostBloc>()
                                  .add(const CreatePostImageSubmitted());
                              Navigator.of(context).pop();
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: BlocBuilder<CreatePostBloc, CreatePostState>(
                  builder: (context, state) {
                    if (state.previousImage != null &&
                        state.previousImage!.isNotEmpty) {
                      return Stack(
                        children: [
                          CachedImage(
                            fit: BoxFit.contain,
                            state.previousImage!,
                            width: context.rWidth,
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                context.read<CreatePostBloc>()
                                  ..add(const CreatePostImageChanged(''))
                                  ..add(const CreatePostImageSubmitted());
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add an Image'),
                        Icon(Icons.attach_file_outlined)
                      ],
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            BlocBuilder<CreatePostBloc, CreatePostState>(
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(context.rWidth, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  key: const Key('createPost_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () {
                          context.read<CreatePostBloc>().add(
                                CreatePostSubmitted(
                                  context.read<AuthBloc>().state.user!.id,
                                ),
                              );
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Post'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
