import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final cred = await authService.value
          .createUser(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .timeout(const Duration(seconds: 15));

      await cred.user?.sendEmailVerification().timeout(const Duration(seconds: 15));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác minh.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // về login
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Firebase timeout. Kiểm tra mạng/emulator Google Play.'),
          backgroundColor: Colors.red,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String msg = e.message ?? 'Đăng ký thất bại';
      if (e.code == 'email-already-in-use') msg = 'Email đã được sử dụng';
      if (e.code == 'invalid-email') msg = 'Email không hợp lệ';
      if (e.code == 'weak-password') msg = 'Mật khẩu yếu (>=6 ký tự)';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Tạo tài khoản',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đăng ký bằng Email và xác minh bằng link',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final v = (value ?? '').trim();
                    if (v.isEmpty) return 'Vui lòng nhập email';
                    if (!v.contains('@')) return 'Email không hợp lệ';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePass,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                  validator: (value) {
                    final v = value ?? '';
                    if (v.isEmpty) return 'Vui lòng nhập mật khẩu';
                    final passwordRegex =
                    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');
                    if (!passwordRegex.hasMatch(v)) {
                      return 'Phải có chữ hoa, chữ thường và số (>=6 ký tự)';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirm,
                  decoration: InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_hideConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                    ),
                  ),
                  validator: (value) {
                    final v = value ?? '';
                    if (v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                    if (v != _passwordController.text) return 'Mật khẩu không khớp';
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Đăng ký'),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Đã có tài khoản?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đăng nhập'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}