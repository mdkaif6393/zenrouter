part of '../../coordinator.dart';

/// Settings layout - provides navigation structure for /settings/*
///
/// File: routes/settings/+layout.dart
/// Convention: +layout.dart files define RouteLayout for their directory
class SettingsLayout extends AppRoute with RouteLayout {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.settingsStack;

  @override
  Uri toUri() => Uri.parse('/settings');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => coordinator.pop(),
        ),
      ),
      body: RouteLayout.buildPrimitivePath(
        NavigationPath,
        coordinator,
        coordinator.settingsStack,
        this,
      ),
    );
  }
}
