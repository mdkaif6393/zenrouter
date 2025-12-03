part of '../../coordinator.dart';

/// Settings layout - provides navigation structure for /settings/*
///
/// File: routes/settings/+layout.dart
/// Convention: +layout.dart files define RouteLayout for their directory
class SettingsLayout extends AppRoute with RouteLayout {
  SettingsLayout._();
  static final instance = SettingsLayout._();

  @override
  DynamicNavigationPath resolvePath(covariant Coordinator coordinator) {
    final appCoordinator = coordinator as AppCoordinator;
    return appCoordinator.settingsStack;
  }

  @override
  Uri toUri() => Uri.parse('/settings');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    final appCoordinator = coordinator as AppCoordinator;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => coordinator.pop(),
        ),
      ),
      body: RouteLayout.defaultBuildForDynamicPath(
        coordinator,
        appCoordinator.settingsStack,
      ),
    );
  }
}
