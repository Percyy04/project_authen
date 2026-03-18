import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService() {
    _auth.setLanguageCode('vi');
    // if (kDebugMode) {
    //   _auth.setSettings(appVerificationDisabledForTesting: true);
    // }
  }

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _auth
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
    return _auth
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
      await user.updateDisplayName(username).timeout(const Duration(seconds: 15));
    }
  }

  Future<void> deleteAccount({
    required String password,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password,
    );

    await user
        .reauthenticateWithCredential(credential)
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

    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: currentPassword,
    );

    await user
        .reauthenticateWithCredential(credential)
        .timeout(const Duration(seconds: 15));

    await user.updatePassword(newPassword).timeout(const Duration(seconds: 15));
  }

  // === PHONE AUTH ===

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneCodeSent codeSent,
    required PhoneVerificationFailed verificationFailed,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? forceResendingToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),
      timeout: const Duration(seconds: 60),
      forceResendingToken: forceResendingToken,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(credential).timeout(const Duration(seconds: 20));
  }
}