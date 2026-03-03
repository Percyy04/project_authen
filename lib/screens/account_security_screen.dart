import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _isBiometricEnabled = true;
  bool _isTwoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Bảo mật tài khoản', 
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // --- SECURITY SCORE HEADER ---
                  _buildSecurityDashboard(colorScheme, theme),
                  
                  const SizedBox(height: 32),
                  
                  // --- SECTION: AUTHENTICATION ---
                  _buildSectionLabel(theme, 'Xác thực & Truy cập'),
                  _buildModernCard(
                    children: [
                      _buildActionTile(
                        icon: Icons.vpn_key_outlined,
                        color: Colors.blue,
                        title: 'Mật khẩu đăng nhập',
                        subtitle: 'Cập nhật 3 tháng trước',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildActionTile(
                        icon: Icons.face_unlock_outlined,
                        color: Colors.orange,
                        title: 'Sinh trắc học',
                        subtitle: 'FaceID / Vân tay',
                        trailing: Switch(
                          value: _isBiometricEnabled,
                          onChanged: (v) => setState(() => _isBiometricEnabled = v),
                        ),
                      ),
                      _buildDivider(),
                      _buildActionTile(
                        icon: Icons.verified_user_outlined,
                        color: Colors.green,
                        title: 'Xác thực 2 lớp (2FA)',
                        subtitle: 'Bảo mật qua SMS/Email',
                        trailing: Switch(
                          value: _isTwoFactorEnabled,
                          onChanged: (v) => setState(() => _isTwoFactorEnabled = v),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION: DEVICE MANAGEMENT ---
                  _buildSectionLabel(theme, 'Quản lý thiết bị'),
                  _buildModernCard(
                    children: [
                      _buildActionTile(
                        icon: Icons.important_devices_outlined,
                        color: Colors.indigo,
                        title: 'Thiết bị đã tin cậy',
                        subtitle: 'iPhone 15 Pro, Macbook Pro',
                        onTap: () {},
                      ),
                      _buildDivider(),
                      _buildActionTile(
                        icon: Icons.history_toggle_off_rounded,
                        color: Colors.teal,
                        title: 'Lịch sử đăng nhập',
                        subtitle: 'Hà Nội, Việt Nam • Vừa xong',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION: PRIVACY ---
                  _buildSectionLabel(theme, 'Quyền riêng tư'),
                  _buildModernCard(
                    children: [
                      _buildActionTile(
                        icon: Icons.visibility_off_outlined,
                        color: Colors.blueGrey,
                        title: 'Ẩn số dư',
                        subtitle: 'Hiển thị ***** trên màn hình chính',
                        trailing: Switch(value: true, onChanged: (v) {}),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  
                  // --- DANGER ZONE ---
                  _buildEmergencyButton(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityDashboard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.9),
            colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bảo mật tuyệt vời!',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tài khoản của bạn đang được bảo vệ bởi các lớp bảo mật mạnh nhất.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildModernCard({required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 60, endIndent: 16, color: Colors.grey.withOpacity(0.1));
  }

  Widget _buildEmergencyButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.gpp_maybe_rounded, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Khóa tài khoản khẩn cấp',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
