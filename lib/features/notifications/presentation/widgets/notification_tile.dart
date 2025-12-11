import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final String type;
  const NotificationTile({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
  });

  IconData _iconFor(String t) {
    switch (t) {
      case 'like':
        return Icons.favorite_border;
      case 'comment':
        return Icons.mode_comment_outlined;
      case 'follow':
        return Icons.person_add_alt;
      case 'mention':
        return Icons.alternate_email;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(_iconFor(type))),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(body),
      trailing: Text(time, style: Theme.of(context).textTheme.bodySmall),
      onTap: () {},
    );
  }
}
