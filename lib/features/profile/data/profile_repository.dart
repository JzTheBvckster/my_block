import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/firestore_service.dart';

class ProfileRepository {
  final FirestoreService _service;

  ProfileRepository(this._service);

  Future<void> createUserProfile(User user, {String? username}) async {
    await _service.createUserDocument(user, username: username);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
    String uid,
  ) async {
    return _service.getDocument(collection: 'users', docId: uid);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _service.updateDocument(collection: 'users', docId: uid, data: data);
  }

  Stream<List<Map<String, dynamic>>> watchUserPosts(
    String uid, {
    int limit = 12,
  }) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
