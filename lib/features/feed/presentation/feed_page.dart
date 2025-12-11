import 'package:flutter/material.dart';
import 'package:my_block/features/feed/presentation/widgets/bottom_nav.dart';

import '../../messages/presentation/messages_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../../core/widgets/spacing.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
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
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const _StoriesRow(),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return const _PostCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard();

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalPadding = 8.0;
          const separatorWidth = 12.0; // Gap.wmd width
          // Ensure exactly 4 items are visible within the available width
          final available =
              constraints.maxWidth -
              (horizontalPadding * 2) -
              (separatorWidth * 3);
          final itemWidth = available / 4;

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemBuilder: (context, index) {
              return SizedBox(
                width: itemWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircleAvatar(radius: 36),
                    Gap.sm,
                    Text('Story'),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: separatorWidth),
            itemCount: 12,
          );
        },
      ),
    );
  }
}

class _PostCardState extends State<_PostCard> {
  int likes = 0;
  bool liked = false;

  void _toggleLike() {
    setState(() {
      liked = !liked;
      likes += liked ? 1 : -1;
    });
    // TODO: Integrate with FeedRepository to batch update like count.
  }

  Future<void> _replyToPost() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reply'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Write a reply...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Send'),
            ),
          ],
        );
      },
    );

    if ((result ?? '').isNotEmpty) {
      // TODO: Integrate with FeedRepository to add a comment/reply.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reply sent')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(radius: 16),
                Gap.wsm,
                Text('Dancer Name'),
                Spacer(),
                Icon(Icons.more_horiz),
              ],
            ),
            Gap.md,
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Gap.md,
            const Text('A nigga dancing ruggedly and roughly'),
            Gap.sm,
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? Theme.of(context).colorScheme.primary : null,
                  ),
                  onPressed: _toggleLike,
                ),
                Text('$likes'),
                Gap.wmd,
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: _replyToPost,
                ),
                const Text('Reply'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
