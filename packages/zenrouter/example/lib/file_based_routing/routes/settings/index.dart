part of '../../coordinator.dart';

/// Settings index route
///
/// File: routes/settings/index.dart
/// URL: /settings
/// Convention: index.dart represents the default route for the directory
class SettingsIndexRoute extends AppRoute {
  @override
  Type get layout => SettingsLayout;

  @override
  Uri toUri() => Uri.parse('/settings');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        _buildSettingOption(
          context,
          coordinator,
          'Account',
          'Manage your account details',
          Icons.person,
          SettingsAccountRoute(),
        ),
        const Divider(),

        _buildSettingOption(
          context,
          coordinator,
          'Privacy',
          'Privacy and security settings',
          Icons.privacy_tip,
          SettingsPrivacyRoute(),
        ),
        const Divider(),

        _buildSettingOption(
          context,
          coordinator,
          'Notifications',
          'Configure notification preferences',
          Icons.notifications,
          null, // Not implemented yet
        ),
        const Divider(),

        _buildSettingOption(
          context,
          coordinator,
          'Appearance',
          'Theme and display settings',
          Icons.palette,
          null, // Not implemented yet
        ),
      ],
    );
  }

  Widget _buildSettingOption(
    BuildContext context,
    Coordinator coordinator,
    String title,
    String subtitle,
    IconData icon,
    AppRoute? route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: route != null
          ? () => coordinator.push(route)
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title not implemented yet')),
              );
            },
    );
  }
}
