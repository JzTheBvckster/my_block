import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_block/features/feed/presentation/widgets/post_card.dart';
import 'package:provider/provider.dart';

import '../data/profile_repository.dart';
import '../../auth/data/auth_provider.dart' as my_auth;
import '../../auth/presentation/login_page.dart';
import '../../messages/presentation/messages_page.dart';
import '../../feed/presentation/feed_page.dart';
import '../../../core/widgets/spacing.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    }

    final repo = context.read<ProfileRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MessagesPage()));
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: repo.getUserProfile(user.uid),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() ?? {};
          final displayName =
              data['displayName'] as String? ?? user.email ?? 'User';
          final username = data['username'] as String? ?? '';
          final photoURL = data['photoURL'] as String? ?? '';
          final followers = data['followers'] as int? ?? 0;
          final following = data['following'] as int? ?? 0;
          final bio = data['bio'] as String? ?? '';

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: photoURL.isNotEmpty
                        ? NetworkImage(photoURL)
                        : null,
                    child: photoURL.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  Gap.md,
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (username.isNotEmpty)
                    Text(
                      '@$username',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  Gap.sm,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Stat(label: 'Followers', value: followers),
                      Gap.wxl,
                      _Stat(label: 'Following', value: following),
                    ],
                  ),
                ],
              ),
              Gap.lg,
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Gap.sm,
                      Text(
                        bio.isNotEmpty ? bio : 'No bio yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Gap.lg,
              // Temporarily reuse PostCard without header until real posts are wired
              const PostCard(showHeader: false),
              Gap.sm,
              const PostCard(showHeader: false),
              Gap.sm,
              const PostCard(showHeader: false),
              Gap.xl,
              FilledButton.icon(
                onPressed: () async {
                  final auth = context.read<my_auth.AuthProvider>();
                  final navigator = Navigator.of(context);
                  await auth.signOut();
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const FeedPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecentPostsGrid extends StatelessWidget {
  final String uid;
  const _RecentPostsGrid({required this.uid});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ProfileRepository>();
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: repo.watchUserPosts(uid, limit: 12),
      builder: (context, snapshot) {
        final posts = snapshot.data ?? const [];
        if (snapshot.connectionState == ConnectionState.waiting &&
            posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (posts.isEmpty) {
          return const Text('No posts yet');
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final p = posts[index];
            final mediaUrl = p['mediaUrl'] as String? ?? '';
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: mediaUrl.isNotEmpty
                    ? Image.network(mediaUrl, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 32),
              ),
            );
          },
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$value',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
