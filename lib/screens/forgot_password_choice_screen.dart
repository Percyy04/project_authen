import 'package:flutter/material.dart';
import 'forgot_password_email_screen.dart';

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
              'Đặt lại mật khẩu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nhập email để nhận link đặt lại mật khẩu.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.email_outlined),
              label: const Text('Reset qua Email'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordEmailScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}