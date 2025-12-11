import 'package:flutter/material.dart';
import '../../../../core/widgets/spacing.dart';

class PostCard extends StatefulWidget {
  final bool showHeader;
  const PostCard({super.key, this.showHeader = true});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int likes = 0;
  bool liked = false;

  void _toggleLike() {
    setState(() {
      liked = !liked;
      likes += liked ? 1 : -1;
    });
  }

  Future<void> _replyToPost() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
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
      ),
    );
    if ((result ?? '').isNotEmpty) {
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
            if (widget.showHeader) ...[
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
            ],
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Gap.md,
            const Text('Rugged niggas doing the rugged nigga dancing forever.'),
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
