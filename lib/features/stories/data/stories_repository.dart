import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesRepository {
  final FirebaseFirestore _db;
  StoriesRepository(this._db);

  Stream<List<Map<String, dynamic>>> watchStories({int limit = 20}) {
    return _db
        .collection('stories')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Future<void> addStory(
    String uid, {
    required String mediaUrl,
    String? caption,
  }) async {
    final doc = _db.collection('stories').doc();
    await doc.set({
      'id': doc.id,
      'uid': uid,
      'mediaUrl': mediaUrl,
      'caption': caption ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': FieldValue.serverTimestamp(),
    });
  }
}
