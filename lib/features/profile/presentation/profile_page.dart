import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: photoURL.isNotEmpty
                        ? NetworkImage(photoURL)
                        : null,
                    child: photoURL.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  Gap.wlg,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (username.isNotEmpty)
                          Text(
                            '@$username',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        Gap.sm,
                        Row(
                          children: [
                            _Stat(label: 'Followers', value: followers),
                            Gap.wmd,
                            _Stat(label: 'Following', value: following),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap.lg,
              Text(
                bio.isNotEmpty ? bio : 'No bio yet',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
