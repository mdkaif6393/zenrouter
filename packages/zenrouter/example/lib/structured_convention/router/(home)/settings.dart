part of '../../coordinator.dart';

class Settings extends HomeShell with RouteBuilder {
  @override
  Uri? toUri() => Uri.parse('/settings');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return SettingsPage();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings Page')),
      body: Center(
        child: TextButton(
          onPressed: () {
            authService.isAuthenticated = false;
            coordinator.replace(Login());
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
