import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() => _auth.signOut();
}
