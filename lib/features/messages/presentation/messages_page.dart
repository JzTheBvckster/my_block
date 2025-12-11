import 'package:flutter/material.dart';

import '../../../core/widgets/spacing.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: 12,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return const _ChatTile();
        },
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(radius: 20),
        Gap.wmd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Dancer', style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                'Latest message preview goes here',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right),
      ],
    );
  }
}
