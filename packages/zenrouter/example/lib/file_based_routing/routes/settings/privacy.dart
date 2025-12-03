part of '../../coordinator.dart';

/// Privacy settings route
///
/// File: routes/settings/privacy.dart
/// URL: /settings/privacy
/// Convention: Named files represent subdirectories or specific routes
class SettingsPrivacyRoute extends AppRoute {
  @override
  Type get layout => SettingsLayout;

  @override
  Uri toUri() => Uri.parse('/settings/privacy');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Privacy Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Control how your data is used and shared',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),

        _PrivacyToggle(
          title: 'Profile Visibility',
          subtitle: 'Make your profile visible to other users',
          value: true,
          onChanged: (value) {},
        ),

        _PrivacyToggle(
          title: 'Activity Status',
          subtitle: 'Show when you\'re active',
          value: false,
          onChanged: (value) {},
        ),

        _PrivacyToggle(
          title: 'Search Engine Indexing',
          subtitle: 'Allow search engines to index your profile',
          value: true,
          onChanged: (value) {},
        ),

        const Divider(height: 32),

        const Text(
          'Data & Analytics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        _PrivacyToggle(
          title: 'Usage Analytics',
          subtitle: 'Help improve the app by sharing usage data',
          value: true,
          onChanged: (value) {},
        ),

        _PrivacyToggle(
          title: 'Personalized Recommendations',
          subtitle: 'Get recommendations based on your activity',
          value: true,
          onChanged: (value) {},
        ),

        const SizedBox(height: 32),

        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Download Your Data'),
                content: const Text(
                  'Request a copy of your data. You\'ll receive an email when it\'s ready.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data download requested'),
                        ),
                      );
                    },
                    child: const Text('Request'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text('Download Your Data'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

class _PrivacyToggle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacyToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_PrivacyToggle> createState() => _PrivacyToggleState();
}

class _PrivacyToggleState extends State<_PrivacyToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      value: _value,
      onChanged: (value) {
        setState(() => _value = value);
        widget.onChanged(value);
      },
    );
  }
}
