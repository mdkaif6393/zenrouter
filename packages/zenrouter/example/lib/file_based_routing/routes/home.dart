part of '../coordinator.dart';

/// Home route - the main landing page
///
/// File: routes/home.dart
/// URL: /home or /
/// Convention: Top-level routes are simple files
class HomeRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/home');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () => coordinator.push(ProductDetailRoute(id: '1')),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => coordinator.push(SettingsAccountRoute()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to ZenRouter!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'File-Based Routing Example',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => coordinator.push(ProductsIndexRoute()),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Browse Products'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => coordinator.push(SettingsAccountRoute()),
              icon: const Icon(Icons.settings),
              label: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
