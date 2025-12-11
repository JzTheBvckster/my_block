import 'package:flutter/material.dart';

import '../data/notifications_repository.dart';
import 'widgets/notification_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _repo = NotificationsRepository();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return const Center(child: Text('No notifications'));
          }
          // Partition into sections
          bool isToday(Map<String, dynamic> m) {
            final t = (m['time'] as String).toLowerCase();
            return t.endsWith('m') || t.endsWith('h');
          }

          final today = items.where(isToday).toList();
          final week = items.where((m) => !isToday(m)).toList();

          final merged = <Map<String, dynamic>>[];
          if (today.isNotEmpty) {
            merged.add({'header': 'Today'});
            merged.addAll(today);
          }
          if (week.isNotEmpty) {
            merged.add({'header': 'This week'});
            merged.addAll(week);
          }

          bool _isHeaderAt(int i) => merged[i].containsKey('header');

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: merged.length,
            separatorBuilder: (_, i) {
              if (i >= merged.length - 1) return const SizedBox.shrink();
              // No divider around headers
              if (_isHeaderAt(i) || _isHeaderAt(i + 1)) {
                return const SizedBox.shrink();
              }
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              final m = merged[index];
              if (_isHeaderAt(index)) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Text(
                    m['header'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }
              return NotificationTile(
                title: m['title'] as String,
                body: m['body'] as String,
                time: m['time'] as String,
                type: m['type'] as String,
              );
            },
          );
        },
      ),
    );
  }
}
