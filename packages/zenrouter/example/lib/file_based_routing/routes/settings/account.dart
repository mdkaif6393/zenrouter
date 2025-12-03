part of '../../coordinator.dart';

/// Account settings route
///
/// File: routes/settings/account.dart
/// URL: /settings/account
/// Convention: Named files represent subdirectories or specific routes
class SettingsAccountRoute extends AppRoute {
  @override
  RouteLayout? get layout => SettingsLayout.instance;

  @override
  Uri toUri() => Uri.parse('/settings/account');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Account Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        _buildAccountField('Email', 'user@example.com', Icons.email),
        const SizedBox(height: 16),

        _buildAccountField('Username', 'johndoe', Icons.person),
        const SizedBox(height: 16),

        _buildAccountField('Phone', '+1 (555) 123-4567', Icons.phone),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Save functionality not implemented'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Save Changes'),
        ),
        const SizedBox(height: 12),

        OutlinedButton(
          onPressed: () => coordinator.pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildAccountField(String label, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(Icons.edit, size: 20),
      ),
    );
  }
}
