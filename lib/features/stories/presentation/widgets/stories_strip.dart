import 'package:flutter/material.dart';
import 'story_bubble.dart';

class StoriesStrip extends StatelessWidget {
  const StoriesStrip({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data until backend is wired
    const placeholderUsers = [
      'Aaliyah',
      'Diego',
      'Mina',
      'Ravi',
      'Zoe',
      'Kenji',
      'Luna',
      'Mateo',
      'Priya',
      'Noah',
      'Sofia',
      'Leo',
    ];

    return SizedBox(
      height: 120,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalPadding = 8.0;
          const separatorWidth = 12.0;
          final available =
              constraints.maxWidth -
              (horizontalPadding * 2) -
              (separatorWidth * 3);
          final itemWidth = available / 4; // ensure 4 visible

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: placeholderUsers.length,
            separatorBuilder: (_, __) => const SizedBox(width: separatorWidth),
            itemBuilder: (context, index) {
              final name = placeholderUsers[index];
              return SizedBox(
                width: itemWidth,
                child: StoryBubble(username: name, imageUrl: ''),
              );
            },
          );
        },
      ),
    );
  }
}
