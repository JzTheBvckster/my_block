import 'package:flutter/material.dart';

import '../data/explore_repository.dart';
import 'widgets/trending_tile.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _repo = ExploreRepository();
  final _items = <Map<String, dynamic>>[];
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _loading = false;
  bool _end = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading || _end) return;
    setState(() => _loading = true);
    final next = await _repo.fetchPaginatedItems(limit: 18);
    if (mounted) {
      setState(() {
        _items.addAll(next);
        _loading = false;
        if (next.isEmpty) _end = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleItems = _query.isEmpty
        ? _items
        : _items
              .where(
                (m) => (m['title'] as String).toLowerCase().contains(
                  _query.toLowerCase(),
                ),
              )
              .toList();
    // Show many items (around 18) with uniform sizing

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: const Text('Explore'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 400) {
            _loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= visibleItems.length) return const SizedBox();
                  final m = visibleItems[index];
                  return TrendingTile(
                    title: m['title'] as String,
                    color: Color(m['color'] as int),
                  );
                }, childCount: visibleItems.length),
              ),
            ),
            if (_loading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (_end && _items.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: Text('No trending items yet')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  _SearchBarDelegate({required this.controller, required this.onChanged});

  @override
  double get minExtent => 64;

  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search dancers, tags, or posts',
            prefixIcon: Icon(Icons.search),
            isDense: true,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
