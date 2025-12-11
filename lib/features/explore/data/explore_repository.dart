import 'dart:math';

class ExploreRepository {
  ExploreRepository();

  Future<List<Map<String, dynamic>>> fetchPaginatedItems({
    String? lastId,
    int limit = 18,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final rng = Random(42);
    return List.generate(limit, (i) {
      final id = lastId == null ? i : i + 1;
      return {
        'id': 'item_$id',
        'title': 'Trending #$id',
        'color': 0xFF000000 | rng.nextInt(0x00FFFFFF),
      };
    });
  }
}
