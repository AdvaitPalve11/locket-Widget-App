import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      // Debug print for development only
      if (kDebugMode) debugPrint('Error signing in: $e');
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      AppLogger.error('Error registering user', e, null, 'AuthService');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      AppLogger.error('Error signing out user', e, null, 'AuthService');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      AppLogger.error('Error sending password reset email', e, null, 'AuthService');
    }
  }
}