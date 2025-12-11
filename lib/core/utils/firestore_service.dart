import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Lightweight Firestore service with reusable helpers.
class FirestoreService {
  final FirebaseFirestore _db;
  FirestoreService(this._db);

  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await _db
        .collection(collection)
        .doc(docId)
        .set(data, merge ? SetOptions(merge: true) : null);
  }

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String docId,
  }) async {
    return _db.collection(collection).doc(docId).get();
  }

  /// Convenience: create a base user document on signup.
  Future<void> createUserDocument(User user, {String? username}) async {
    final data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'followers': 0,
      'following': 0,
      'bio': '',
      if (username != null && username.isNotEmpty) 'username': username,
    };
    await setDocument(
      collection: 'users',
      docId: user.uid,
      data: data,
      merge: true,
    );
  }
}
