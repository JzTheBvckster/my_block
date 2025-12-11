import 'package:flutter/material.dart';

import 'features/feed/presentation/feed_page.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/explore/presentation/explore_page.dart';
import 'features/notifications/presentation/notifications_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          FeedPage(),
          ExplorePage(),
          NotificationsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Navigate to create post page
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
