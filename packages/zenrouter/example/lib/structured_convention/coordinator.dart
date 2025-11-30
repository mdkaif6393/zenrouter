import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zenrouter/zenrouter.dart';
import 'package:zenrouter_devtools/zenrouter_devtools.dart';

/// HOME SHELL
part 'router/(home)/+shell.dart';

/// HOME FEED
part 'router/(home)/feed/+route.dart';
part 'router/(home)/feed/ads.dart'; // This is belong to feed in semantic route but it's belong to root since it is a dialog
part 'router/(home)/notification.dart';
part 'router/(home)/search.dart';
part 'router/(home)/settings.dart';

/// AUTH ROUTE
part 'router/auth/login.dart';
part 'router/auth/register.dart';

/// NOT FOUND ROUTE
part 'router/not_found.dart';

sealed class AppRoute extends RouteTarget with RouteUnique {
  @override
  NavigationPath getPath(AppCoordinator coordinator) => coordinator.root;
}

class AppCoordinator extends Coordinator<AppRoute>
    with CoordinatorDebug<AppRoute> {
  final home = ReadOnlyNavigationPath<HomeShell>([
    Feed(),
    Notification(),
    Search(),
    Settings(),
  ]);

  @override
  List<NavigationPath<RouteTarget>> get paths => [root, home];

  @override
  String debugLabel(NavigationPath<RouteTarget> path) {
    if (path == root) return 'root';
    if (path == home) return 'home';
    return super.debugLabel(path);
  }

  @override
  List<AppRoute> get debugRoutes => [
    Feed(),
    FeedAds(),
    Login(),
    Register(),
    Notification(),
    Search(),
    Settings(),
    NotFound(Uri.parse('/something-went-wrong')),
  ];

  @override
  AppRoute parseRouteFromUri(Uri uri) {
    return switch (uri.pathSegments) {
      ['auth', 'login'] => Login(
        redirectTo: Uri.tryParse(uri.queryParameters['redirect'] ?? '/'),
      ),
      ['auth', 'register'] => Register(),
      ['feeds'] => Feed(),
      ['feeds', 'ads'] => FeedAds(),
      ['notification'] => Notification(),
      ['search'] => Search(),
      ['settings'] => Settings(),
      [] => Feed(),
      _ => NotFound(uri),
    };
  }
}

final coordinator = AppCoordinator();

class AuthService {
  bool isAuthenticated = false;
}

final authService = AuthService();

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Counter: $counter'),
        ElevatedButton(
          onPressed: () => setState(() => counter++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
