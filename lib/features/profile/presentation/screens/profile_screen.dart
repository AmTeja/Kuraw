import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuraw/core/data/model/user.dart';
import 'package:kuraw/core/util/context_extensions.dart';
import 'package:kuraw/features/profile/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(this.uid, {super.key});

  final String uid;

  static Route<void> route(String uid) {
    return MaterialPageRoute<void>(
      builder: (_) => ProfilePage(uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        profileRepository: context.read(),
      )..add(ProfileFetch(uid)),
      child: const ProfileScaffold(),
    );
  }
}

class ProfileScaffold extends StatelessWidget {
  const ProfileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileLoaded) {
              return const ProfileView();
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final user = state.user;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Column(
                children: [
                  ProfileHeader(user: user),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Posts',
                        style: context.textTheme.headlineSmall,
                      ),
                      Text(
                        user.posts.length.toString(),
                        style: context.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {});
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 60,
          backgroundImage: CachedNetworkImageProvider(
            user.profilePicture,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.username,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          user.bio,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}
