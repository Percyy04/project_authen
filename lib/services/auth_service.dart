import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final ValueNotifier<AuthService> authService =
ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    _auth.setLanguageCode('vi');
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth
        .signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    )
        .timeout(const Duration(seconds: 15));
  }

  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) async {
    return await _auth
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    )
        .timeout(const Duration(seconds: 15));
  }

  Future<void> signOut() async {
    await _auth.signOut().timeout(const Duration(seconds: 10));
  }

  Future<void> resetPassword({required String email}) async {
    await _auth
        .sendPasswordResetEmail(email: email.trim())
        .timeout(const Duration(seconds: 15));
  }

  Future<void> updateUsername({required String username}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(username)
          .timeout(const Duration(seconds: 15));
    }
  }

  Future<void> deleteAccount({
    required String password,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    AuthCredential credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await user.reauthenticateWithCredential(credential)
        .timeout(const Duration(seconds: 15));

    await user.delete().timeout(const Duration(seconds: 15));
    await _auth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    AuthCredential credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential)
        .timeout(const Duration(seconds: 15));

    await user.updatePassword(newPassword)
        .timeout(const Duration(seconds: 15));
  }
}