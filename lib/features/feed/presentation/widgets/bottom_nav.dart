import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
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
    );
  }
}
