import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/auth_provider.dart';
import 'package:taskify/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          title: 'Account',
          children: [
            _buildProfileCard(context, user?.name ?? 'Guest User', user?.email ?? 'guest@example.com'),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              title: 'Edit Profile',
              icon: Icons.person_outline,
              onTap: () {},
            ),
            _buildSettingItem(
              context,
              title: 'Change Password',
              icon: Icons.lock_outline,
              onTap: () {},
            ),
            _buildSettingItem(
              context,
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              onTap: () {},
            ),
          ],
        ),
        _buildSection(
          title: 'Appearance',
          children: [
            _buildSwitchItem(
              context,
              title: 'Dark Mode',
              icon: Icons.dark_mode_outlined,
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            _buildSettingItem(
              context,
              title: 'Text Size',
              icon: Icons.text_fields,
              trailing: DropdownButton<String>(
                value: 'Medium',
                underline: const SizedBox(),
                items: ['Small', 'Medium', 'Large'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
            ),
          ],
        ),
        _buildSection(
          title: 'Task Settings',
          children: [
            _buildSwitchItem(
              context,
              title: 'Show Completed Tasks',
              icon: Icons.check_circle_outline,
              value: true,
              onChanged: (value) {},
            ),
            _buildSwitchItem(
              context,
              title: 'Show Task Deadlines',
              icon: Icons.calendar_today_outlined,
              value: true,
              onChanged: (value) {},
            ),
            _buildSettingItem(
              context,
              title: 'Default Priority',
              icon: Icons.flag_outlined,
              trailing: DropdownButton<String>(
                value: 'Medium',
                underline: const SizedBox(),
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
            ),
          ],
        ),
        _buildSection(
          title: 'About',
          children: [
            _buildSettingItem(
              context,
              title: 'App Version',
              icon: Icons.info_outline,
              trailing: const Text('1.0.0'),
            ),
            _buildSettingItem(
              context,
              title: 'Terms of Service',
              icon: Icons.description_outlined,
              onTap: () {},
            ),
            _buildSettingItem(
              context,
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildProfileCard(BuildContext context, String name, String email) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.primary,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
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
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.black54,
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.black54,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
