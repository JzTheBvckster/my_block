import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'auth_repository.dart';
import '../../profile/data/profile_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  final ProfileRepository _profileRepo;
  AuthProvider(this._repo, this._profileRepo) {
    _subscription = _repo.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;
  User? currentUser;
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _repo.signInWithEmailPassword(email: email, password: password);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    try {
      final cred = await _repo.signUpWithEmailPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _profileRepo.createUserProfile(user);
      }
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpWithUsername(
    String email,
    String password,
    String username,
  ) async {
    _setLoading(true);
    try {
      final cred = await _repo.signUpWithEmailPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _profileRepo.createUserProfile(user, username: username);
      }
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _repo.sendPasswordResetEmail(email: email);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _repo.signOut();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }
}
