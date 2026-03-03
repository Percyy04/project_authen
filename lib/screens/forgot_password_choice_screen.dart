import 'package:flutter/material.dart';
import 'forgot_password_email_screen.dart';
import 'forgot_password_phone_screen.dart';

class ForgotPasswordChoiceScreen extends StatelessWidget {
  const ForgotPasswordChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Chọn cách lấy lại mật khẩu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn có thể reset qua Email hoặc xác thực OTP bằng SĐT.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.email_outlined),
              label: const Text('Reset qua Email'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordEmailScreen()),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.sms_outlined),
              label: const Text('Reset qua OTP (SĐT)'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ForgotPasswordPhoneScreen()),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.35)),
              ),
              child: const Text(
                'Lưu ý: Reset bằng OTP (SĐT) yêu cầu số điện thoại đã được liên kết với tài khoản.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}