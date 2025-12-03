import 'package:flutter/material.dart';
import 'package:zenrouter/zenrouter.dart';
import 'package:zenrouter_devtools/zenrouter_devtools.dart';

// Import all routes following the file-based convention
part 'routes/home.dart';
part 'routes/products/+layout.dart';
part 'routes/products/index.dart';
part 'routes/products/:id.dart';
part 'routes/settings/+layout.dart';
part 'routes/settings/index.dart';
part 'routes/settings/account.dart';
part 'routes/settings/privacy.dart';

/// Base class for all routes in this application
///
/// All routes must extend this class to work with the Coordinator
abstract class AppRoute extends RouteTarget with RouteUnique {}

/// Application coordinator that maps file-based routes to URLs
///
/// This coordinator demonstrates how the file-based routing convention
/// translates to URL parsing and navigation.
class AppCoordinator extends Coordinator<AppRoute> with CoordinatorDebug {
  // Navigation paths for each directory
  final homeStack = DynamicNavigationPath<AppRoute>('home');
  final productsStack = DynamicNavigationPath<AppRoute>('products');
  final settingsStack = DynamicNavigationPath<AppRoute>('settings');

  @override
  List<NavigationPath> get paths => [
    root,
    homeStack,
    productsStack,
    settingsStack,
  ];

  @override
  AppRoute parseRouteFromUri(Uri uri) {
    // Map URL segments to file-based routes
    // File structure mirrors URL structure!
    return switch (uri.pathSegments) {
      // routes/home.dart
      [] || ['home'] => HomeRoute(),

      // routes/products/
      ['products'] => ProductsIndexRoute(),
      ['products', final id] => ProductDetailRoute(id: id),

      // routes/settings/
      ['settings'] => SettingsIndexRoute(),
      ['settings', 'account'] => SettingsAccountRoute(),
      ['settings', 'privacy'] => SettingsPrivacyRoute(),

      // Default to home
      _ => HomeRoute(),
    };
  }
}
