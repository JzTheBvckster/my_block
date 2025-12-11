import 'package:flutter/material.dart';
import 'package:my_block/features/feed/presentation/widgets/bottom_nav.dart';

import '../../messages/presentation/messages_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../../core/widgets/spacing.dart';
import 'widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
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
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return const PostCard();
        },
      ),
    );
  }
}

// PostCard moved to widgets/post_card.dart and reused here
