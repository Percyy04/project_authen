import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'forgot_password_choice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = false;

  Future<void> _reloadUser() async {
    setState(() => _loading = true);
    try {
      await authService.value.currentUser?.reload().timeout(const Duration(seconds: 10));
      setState(() {});
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendVerifyEmail() async {
    final user = authService.value.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await user.sendEmailVerification().timeout(const Duration(seconds: 10));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi lại email xác minh.')),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timeout khi gửi email xác minh.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Gửi email xác minh thất bại')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.value.currentUser;
    final email = user?.email ?? '';
    final verified = user?.emailVerified ?? false;
    final phoneVerified = user?.phoneNumber != null;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Reload user',
            onPressed: _loading ? null : _reloadUser,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await authService.value.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin tài khoản',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.email_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        email.isEmpty ? 'Không có email' : email,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      verified ? Icons.verified : Icons.warning_amber_rounded,
                      color: verified ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      verified ? 'Email đã xác minh' : 'Email chưa xác minh',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: verified ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (!verified) ...[
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Xác minh email',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text('Hãy kiểm tra email và bấm link xác minh.'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loading ? null : _sendVerifyEmail,
                      child: _loading
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('Gửi lại email xác minh'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _loading ? null : _reloadUser,
                      child: const Text('Tôi đã xác minh (reload)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Text(
            'Chức năng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Đổi mật khẩu'),
              subtitle: const Text('Đổi mật khẩu khi đang đăng nhập'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openChangePasswordDialog,
            ),
          ),

          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Thêm số diện thoại'),
              subtitle: const Text('Thêm số điện thoại để xác minh'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => print('Update soon'),
            ),
          ),

          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(Icons.lock_reset_outlined),
              title: const Text('Quên mật khẩu'),
              subtitle: const Text('Reset qua Email (màn lựa chọn)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordChoiceScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  bool _hideCur = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);

    try {
      final email = authService.value.currentUser?.email;
      if (email == null) {
        throw Exception('Không tìm thấy email của user.');
      }

      await authService.value
          .resetPasswordFromCurrentPassword(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
        email: email,
      )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đổi mật khẩu thành công ✅')),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timeout khi đổi mật khẩu.')),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Đổi mật khẩu thất bại')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đổi mật khẩu'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentCtrl,
                obscureText: _hideCur,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  suffixIcon: IconButton(
                    icon: Icon(_hideCur ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _hideCur = !_hideCur),
                  ),
                ),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Nhập mật khẩu hiện tại';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _newCtrl,
                obscureText: _hideNew,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_hideNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _hideNew = !_hideNew),
                  ),
                ),
                validator: (v) {
                  final s = v ?? '';
                  if (s.isEmpty) return 'Nhập mật khẩu mới';
                  final passwordRegex =
                  RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$');
                  if (!passwordRegex.hasMatch(s)) {
                    return 'Phải có chữ hoa, chữ thường và số (>=6 ký tự)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: _hideConfirm,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  suffixIcon: IconButton(
                    icon: Icon(_hideConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                  ),
                ),
                validator: (v) {
                  if ((v ?? '').isEmpty) return 'Xác nhận mật khẩu mới';
                  if (v != _newCtrl.text) return 'Mật khẩu không khớp';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _changePassword,
          child: _loading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
              : const Text('Lưu'),
        ),
      ],
    );
  }
}