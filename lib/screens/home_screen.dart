import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin tài khoản',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.email_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user?.email ?? 'Không có email',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Icon(
                  user?.emailVerified == true
                      ? Icons.verified
                      : Icons.warning_amber_rounded,
                  color: user?.emailVerified == true
                      ? Colors.green
                      : Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  user?.emailVerified == true
                      ? 'Email đã xác minh'
                      : 'Email chưa xác minh',
                  style: TextStyle(
                    fontSize: 16,
                    color: user?.emailVerified == true
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 20),

            const Text(
              'Chào mừng bạn đến với hệ thống!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}