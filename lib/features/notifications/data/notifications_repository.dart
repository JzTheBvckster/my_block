class NotificationsRepository {
  NotificationsRepository();

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      {
        'type': 'like',
        'title': 'New like',
        'body': 'Aaliyah liked your post',
        'time': '2m',
      },
      {
        'type': 'follow',
        'title': 'New follower',
        'body': 'Diego started following you',
        'time': '7m',
      },
      {
        'type': 'comment',
        'title': 'New comment',
        'body': 'Mina commented: "🔥🔥"',
        'time': '15m',
      },
      {
        'type': 'mention',
        'title': 'Mention',
        'body': 'Ravi mentioned you in a post',
        'time': '1h',
      },
      {
        'type': 'like',
        'title': 'New like',
        'body': 'Luna liked your post',
        'time': '2h',
      },
      {
        'type': 'comment',
        'title': 'New comment',
        'body': 'Kenji commented: "Nice moves!"',
        'time': '3h',
      },
      {
        'type': 'follow',
        'title': 'New follower',
        'body': 'Zoe started following you',
        'time': '5h',
      },
      {
        'type': 'mention',
        'title': 'Mention',
        'body': 'Mateo mentioned you in a story',
        'time': '8h',
      },
      {
        'type': 'like',
        'title': 'New like',
        'body': 'Priya liked your post',
        'time': '1d',
      },
      {
        'type': 'follow',
        'title': 'New follower',
        'body': 'Noah started following you',
        'time': '2d',
      },
      {
        'type': 'comment',
        'title': 'New comment',
        'body': 'Sofia commented: "So clean!"',
        'time': '3d',
      },
      {
        'type': 'mention',
        'title': 'Mention',
        'body': 'Leo mentioned you in a post',
        'time': '5d',
      },
    ];
  }
}
