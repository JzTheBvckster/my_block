import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/stories_repository.dart';
import '../../../core/widgets/spacing.dart';
import 'widgets/story_bubble.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = StoriesRepository(FirebaseFirestore.instance);
    return Scaffold(
      appBar: AppBar(title: const Text('Stories')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: repo.watchStories(),
        builder: (context, snapshot) {
          final stories = snapshot.data ?? const [];
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => Gap.wmd,
                  itemBuilder: (context, index) {
                    final s = stories[index];
                    return StoryBubble(
                      username: s['username'] ?? 'Dancer',
                      imageUrl: s['mediaUrl'] ?? '',
                    );
                  },
                ),
              ),
              Gap.lg,
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
