import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final _auth = FirebaseAuth.instance;

  Future<String> sendOtp(String phoneE164) async {
    // phoneE164 ví dụ: +84901234567
    String verificationId = '+84783881764';

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) {},

      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },

      codeSent: (String verId, int? resendToken) {
        verificationId = verId;
      },

      codeAutoRetrievalTimeout: (String verId) {
        // nếu hết thời gian, vẫn có thể dùng verId để verify
        verificationId = verId;
      },
    );

    // verifyPhoneNumber chạy callback async,
    // nên đôi khi cần đợi verId được set (thực tế codeSent sẽ set ngay).
    if (verificationId.isEmpty) {
      throw Exception('Không lấy được verificationId. Hãy thử lại.');
    }
    return verificationId;
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _auth.signInWithCredential(credential);
  }
}