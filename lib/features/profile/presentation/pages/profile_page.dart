import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }

        if (state.status == AuthStatus.failure && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final user = state.user;

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFFF8FAFC),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF8FAFC),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: const Color(0xFF3B82F6),
                            child: Text(
                              user != null && user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Unknown user',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF1E3A8A).withOpacity(0.2)
                                : const Color(0xFFDCEEFE),
                            foregroundColor: isDark
                                ? const Color(0xFF93C5FD)
                                : const Color(0xFF2563EB),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Account Section
                _buildSection(
                  context,
                  title: 'Account',
                  isDark: isDark,
                  items: [
                    _SettingsItem(
                      icon: Icons.lock_outline,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: isDark
                          ? const Color(0xFF1E3A8A).withOpacity(0.2)
                          : const Color(0xFFDCEEFE),
                      title: 'Change Password',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Preferences Section
                _buildSection(
                  context,
                  title: 'Preferences',
                  isDark: isDark,
                  items: [
                    _SettingsItem(
                      icon: Icons.notifications_outlined,
                      iconColor: const Color(0xFFA855F7),
                      iconBgColor: isDark
                          ? const Color(0xFF581C87).withOpacity(0.2)
                          : const Color(0xFFFAF5FF),
                      title: 'Push Notifications',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: const Color(0xFF2DD4BF),
                      ),
                    ),
                    _SettingsItem(
                      icon: Icons.contrast_outlined,
                      iconColor: const Color(0xFF2DD4BF),
                      iconBgColor: isDark
                          ? const Color(0xFF134E4A).withOpacity(0.2)
                          : const Color(0xFFCCFBF1),
                      title: 'Appearance',
                      trailingText: 'System',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Admin Section (conditional)
                if (user?.email == 'admin@qualitysphere.com') ...[
                  _buildSection(
                    context,
                    title: 'Admin',
                    isDark: isDark,
                    items: [
                      _SettingsItem(
                        icon: Icons.admin_panel_settings_outlined,
                        iconColor: const Color(0xFF4F46E5),
                        iconBgColor: isDark
                            ? const Color(0xFF312E81).withOpacity(0.2)
                            : const Color(0xFFE0E7FF),
                        title: 'Role Management',
                        onTap: () {
                          Navigator.pushNamed(context, '/users');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Support & Legal Section
                _buildSection(
                  context,
                  title: 'Support & Legal',
                  isDark: isDark,
                  items: [
                    _SettingsItem(
                      icon: Icons.help_outline,
                      iconColor: const Color(0xFF3B82F6),
                      iconBgColor: isDark
                          ? const Color(0xFF1E3A8A).withOpacity(0.2)
                          : const Color(0xFFDCEEFE),
                      title: 'Help & Support',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: Icons.info_outline,
                      iconColor: const Color(0xFF2DD4BF),
                      iconBgColor: isDark
                          ? const Color(0xFF134E4A).withOpacity(0.2)
                          : const Color(0xFFCCFBF1),
                      title: 'About QualitySphere',
                      onTap: () {},
                    ),
                    _SettingsItem(
                      icon: Icons.shield_outlined,
                      iconColor: const Color(0xFFA855F7),
                      iconBgColor: isDark
                          ? const Color(0xFF581C87).withOpacity(0.2)
                          : const Color(0xFFFAF5FF),
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: state.status == AuthStatus.loading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(LogoutRequested());
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: state.status == AuthStatus.loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFEF4444),
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Log Out',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required bool isDark,
    required List<_SettingsItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            ...items.map((item) => _buildSettingsItem(context, item, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    _SettingsItem item,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (item.trailing != null)
                item.trailing!
              else if (item.trailingText != null) ...[
                Text(
                  item.trailingText!,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  size: 24,
                ),
              ] else
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.trailing,
    this.trailingText,
    this.onTap,
  });
}
