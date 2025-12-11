import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../messages/presentation/messages_page.dart';
import '../../../core/widgets/spacing.dart';

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
          return const _PostCard();
        },
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 30),
            label: '',
          ),
          NavigationDestination(icon: Icon(Icons.search, size: 30), label: ''),
          NavigationDestination(
            icon: Icon(Icons.notifications_none, size: 30),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: 30),
            label: '',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (i) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create post page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard();

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
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Gap.md,
            const Text('A compact caption with smooth spacing and dividers.'),
          ],
        ),
      ),
    );
  }
}
