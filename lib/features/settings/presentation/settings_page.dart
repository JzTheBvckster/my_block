import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _SectionHeader('Account'),
          Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  subtitle: Text('Update your profile information'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Privacy'),
                  subtitle: Text('Manage visibility and data settings'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _SectionHeader('Notifications'),
          Card(
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications_none),
                  title: Text('Push notifications'),
                  subtitle: Text('Likes, comments, and mentions'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _SectionHeader('About'),
          Card(
            elevation: 0,
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About this app'),
              subtitle: Text('Version and legal information'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
