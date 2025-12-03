# ZenRouter 🧘

**Three ways to route. One elegant system.**

ZenRouter unifies Flutter navigation into three clear paradigms - choose the approach that fits your needs, from simple imperative navigation to advanced deep linking.

## Why ZenRouter?

🎯 **Three Paradigms** - Imperative, Declarative, or Coordinator - use what fits your app  
⚡ **Progressive** - Start simple, add complexity only when needed  
🔒 **Type-Safe** - Full compile-time route checking  
🛡️ **Powerful Guards** - Prevent unwanted navigation with async guards  
🔗 **Deep Linking** - Built-in URI parsing and web navigation (Coordinator)  
📦 **Minimal Boilerplate** - Clean mixin-based architecture  
🔄 **Efficient Updates** - Myers diff algorithm for state-driven routing (Declarative)  

## Choose Your Approach

### 🎮 Imperative: You Control the Stack

**Best for:** Mobile-only apps, event-driven navigation, migrating from Navigator 1.0

```dart
// Define routes
class HomeRoute extends RouteTarget {}
class ProfileRoute extends RouteTarget {}

// Create a navigation path
final path = DynamicNavigationPath<RouteTarget>();

// Navigate imperatively
await path.push(ProfileRoute());
path.pop();
path.replace([HomeRoute()]);

// Render
NavigationStack(
  path: path,
  resolver: (route) => StackTransition.material(
    route.build(context),
  ),
)
```

✅ Simple and familiar  
✅ Full control over navigation stack  
✅ Event-driven (button clicks, gestures)  

[**→ Imperative Guide**](docs/paradigms/imperative.md)

---

### 📊 Declarative: State Drives Navigation

**Best for:** Tab bars, filtered lists, state-driven UIs, React-like patterns

```dart
// Your state
List<int> pages = [1, 2, 3];
bool showSpecial = false;

// Navigation derives from state
NavigationStack.declarative(
  routes: [
    for (final page in pages) PageRoute(page),
    if (showSpecial) SpecialRoute(),
  ],
  resolver: (route) => StackTransition.material(...),
)

// Change state = navigation updates automatically
setState(() => pages.add(4)); // Myers diff adds only new route!
```

✅ State-driven routing  
✅ Efficient updates with Myers diff  
✅ React-like declarative UI  

[**→ Declarative Guide**](docs/paradigms/declarative.md)

---

### 🗺️ Coordinator: Centralized with Deep Links

**Best for:** Web apps, deep linking, large apps, complex nested navigation

```dart
// Define routes with RouteUnique
class HomeRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return HomeScreen();
  }
}

// Create coordinator
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  AppRoute parseRouteFromUri(Uri uri) {
    return switch (uri.pathSegments) {
      [] => HomeRoute(),
      ['profile'] => ProfileRoute(),
      _ => NotFoundRoute(),
    };
  }
}

// Wire up MaterialApp.router
MaterialApp.router(
  routerDelegate: coordinator.routerDelegate,
  routeInformationParser: coordinator.routeInformationParser,
)
```

✅ Deep linking & web URLs  
✅ Browser back button  
✅ Centralized routing  
✅ Nested navigation  

[**→ Coordinator Guide**](docs/paradigms/coordinator.md)

---

## Quick Comparison

| | Imperative | Declarative | Coordinator |
|---|---|---|---|
| **Complexity** | ⭐ Simple | ⭐⭐ Moderate | ⭐⭐⭐ Advanced |
| **Deep Linking** | ❌ | ❌ | ✅ |
| **Web Support** | ❌ | ❌ | ✅ |
| **State-Driven** | Compatible | ✅ Native | Compatible |
| **Best For** | Mobile apps | Tab bars, lists | Web, large apps |

## Installation

```yaml
dependencies:
  zenrouter: ^0.1.0  # Check pub.dev for latest version
```

## Which Paradigm Should I Use?

```
Do you need web support or deep linking?
│
├─ YES → Use Coordinator
│        ✓ Deep linking, URL sync, browser back button
│
└─ NO → Is your navigation state-driven?
       │
       ├─ YES → Use Declarative
       │        ✓ Efficient state-driven routing with Myers diff
       │
       └─ NO → Use Imperative
                ✓ Simple, direct control
```

[**→ Full Decision Guide**](docs/guides/getting-started.md)

## Core Concepts

### RouteTarget - Base Class

All routes extend `RouteTarget`:

```dart
class MyRoute extends RouteTarget {
  final String userId;
  
  MyRoute(this.userId);
  
  // Important: Implement equality for routes with parameters
  @override
  bool operator ==(Object other) {
    if (!compareWith(other)) return false;
    return other is MyRoute && other.userId == userId;
  }
  
  @override
  int get hashCode => Object.hash(super.hashCode, userId);
}
```

### NavigationPath - Stack Container

Two types of navigation paths:

**DynamicNavigationPath** - Stack-based (push/pop):
```dart
final path = DynamicNavigationPath<RouteTarget>();
path.push(MyRoute());
path.pop();
path.replace([HomeRoute()]);
```

**FixedNavigationPath** - Indexed (tabs, drawers):
```dart
final tabPath = FixedNavigationPath([
  Tab1Route(),
  Tab2Route(),
  Tab3Route(),
]);
tabPath.goToIndexed(1); // Switch to Tab2
```

### Route Mixins - Add Functionality

Mix in behaviors as needed:

```dart
// Use with Coordinator (required for Coordinator)
class MyRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/my-route');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return MyScreen();
  }
}

// Prevent navigation with guards
class FormRoute extends RouteTarget with RouteGuard {
  bool hasUnsavedChanges = false;
  
  @override
  Future<bool> popGuard() async {
    if (!hasUnsavedChanges) return true;
    return await showConfirmDialog(context);
  }
}

// Redirect based on conditions
class ProtectedRoute extends RouteTarget with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async {
    final isAuthenticated = await auth.check();
    return isAuthenticated ? this : LoginRoute();
  }
}

// Custom deep link handling
class ProductRoute extends RouteTarget with RouteDeepLink {
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.custom;
  
  @override
  Future<void> deeplinkHandler(Coordinator coordinator, Uri uri) async {
    // Set up navigation stack, load data, track analytics
    coordinator.replace(ShopTab());
    coordinator.push(this);
    analytics.logDeepLink(uri);
  }
}

// Create navigation hosts (tabs, shells)
class TabHost extends RouteTarget with RouteLayout<AppRoute> {
  @override
  FixedNavigationPath resolvePath(Coordinator coordinator) =>
      coordinator.tabPath;
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    // Build tab bar UI with NavigationStack
  }
}
```

[**→ Mixin System Guide**](docs/api/mixins.md)

## Mixin Decision Guide

```
Using Coordinator?
├─ Yes → Add RouteUnique ✓
│
Creating a navigation host (tabs, shells)?
├─ Yes → Add RouteLayout ✓
│
Need custom page transitions?
├─ Yes → Add RouteTransition ✓
│
Prevent navigation (unsaved changes)?
├─ Yes → Add RouteGuard ✓
│
Conditional routing (auth, permissions)?
├─ Yes → Add RouteRedirect ✓
│
Custom deep link handling?
└─ Yes → Add RouteDeepLink ✓
```

## Common Patterns

### Multi-Step Form (Imperative)

```dart
// Pass state through routes
path.push(Step1(data: FormData()));

// In Step1
void onNext() {
  final updated = data.copyWith(name: nameController.text);
  path.push(Step2(data: updated));
}

// In Step2
void onNext() {
  final updated = data.copyWith(email: emailController.text);
  path.push(ReviewStep(data: updated));
}
```

### Tab Navigation (Declarative or Coordinator)

```dart
// Declarative
int selectedTab = 0;

NavigationStack.declarative(
  routes: [
    HomeRoute(),
    switch (selectedTab) {
      0 => FeedRoute(),
      1 => ProfileRoute(),
      2 => SettingsRoute(),
      _ => FeedRoute(),
    },
  ],
  resolver: resolver,
)

// Coordinator with FixedNavigationPath
final tabPath = FixedNavigationPath([
  FeedRoute(),
  ProfileRoute(),
  SettingsRoute(),
]);

coordinator.push(tabPath.stack[selectedTab]);
```

### Authentication Flow (Coordinator)

```dart
class DashboardRoute extends AppRoute with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async {
    final isLoggedIn = await auth.check();
    return isLoggedIn ? this : LoginRoute();
  }
}

// Automatically redirects to login if not authenticated
coordinator.push(DashboardRoute());
```

### Nested Navigation (Coordinator)

```dart
class AppCoordinator extends Coordinator<AppRoute> {
  // Main navigation
  final homeStack = DynamicNavigationPath<AppRoute>('home');
  
  // Settings navigation (separate stack)
  final settingsStack = DynamicNavigationPath<AppRoute>('settings');
  
  // Tab navigation (indexed)
  final tabPath = FixedNavigationPath<AppRoute>([
    FeedTab(),
    ProfileTab(),
    SettingsTab(),
  ]);
  
  @override
  List<NavigationPath> get paths => [root, homeStack, settingsStack, tabPath];
}
```

## Best Practices

### ✅ Use Sealed Classes

Enable exhaustive pattern matching:

```dart
sealed class AppRoute extends RouteTarget with RouteUnique {}

class HomeRoute extends AppRoute { ... }
class ProfileRoute extends AppRoute { ... }

// Compiler ensures all routes are handled
AppRoute parseRouteFromUri(Uri uri) {
  return switch (uri.pathSegments) {
    [] => HomeRoute(),
    ['profile'] => ProfileRoute(),
    // Compiler error if you forget a route!
  };
}
```

### ✅ Implement Equality for Parameterized Routes

Routes with data fields must override `==` and `hashCode`:

```dart
class UserRoute extends RouteTarget {
  final String userId;
  
  UserRoute(this.userId);
  
  @override
  bool operator ==(Object other) {
    if (!compareWith(other)) return false; // Check base equality
    return other is UserRoute && other.userId == userId;
  }
  
  @override
  int get hashCode => Object.hash(super.hashCode, userId);
}
```

Without this, operations like `pushOrMoveToTop`, `remove`, and redirects won't work correctly!

### ✅ Use Immutable State

Routes should carry immutable state:

```dart
class FormRoute extends RouteTarget {
  final FormData data;
  
  FormRoute({required this.data});
  
  void onNext() {
    final updated = data.copyWith(name: controller.text);
    path.push(NextRoute(data: updated));
  }
}
```

### ✅ Use Guards for Unsaved Changes

Prevent accidental data loss:

```dart
class EditorRoute extends RouteTarget with RouteGuard {
  bool hasUnsavedChanges = false;
  
  @override
  Future<bool> popGuard() async {
    if (!hasUnsavedChanges) return true;
    return await showConfirmDialog() ?? false;
  }
}
```

## Documentation

### **📚 Paradigm Guides**
- [Imperative Navigation](docs/paradigms/imperative.md) - Direct stack control
- [Declarative Navigation](docs/paradigms/declarative.md) - State-driven routing
- [Coordinator Pattern](docs/paradigms/coordinator.md) - Deep linking & web support

### **🔧 API Reference**
- [Route Mixins](docs/api/mixins.md) - RouteUnique, RouteGuard, RouteRedirect, etc.
- [Core Classes](docs/api/core-classes.md) - RouteTarget, StackTransition
- [Navigation Paths](docs/api/navigation-paths.md) - DynamicNavigationPath, FixedNavigationPath
- [Coordinator API](docs/api/coordinator.md) - Full Coordinator reference

### **🚀 Getting Started**
- [Getting Started Guide](docs/guides/getting-started.md) - Quick start for each paradigm
- [Examples](example/) - Complete working examples

## Examples

Check out the `example/` directory for complete examples:

- **[main_imperative.dart](example/lib/main_imperative.dart)** - Multi-step form with state management
- **[main_declrative.dart](example/lib/main_declrative.dart)** - State-driven navigation with Myers diff
- **[main_coordinator.dart](example/lib/main_coordinator.dart)** - Complex nested navigation with deep linking

## Migration

### From Navigator 1.0

ZenRouter's imperative paradigm is similar to Navigator 1.0:

```dart
// Navigator 1.0
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
Navigator.pop(context);

// ZenRouter (Imperative)
path.push(ProfileRoute());
path.pop();
```

### From Navigator 2.0 / GoRouter

Use the Coordinator paradigm:

```dart
// GoRouter
context.go('/profile/123');
context.push('/profile/123')

// ZenRouter (Coordinator)
coordinator.replace(ProfileRoute('123'));
coordinator.push(ProfileRoute('123'));
```

## Platform Support

✅ iOS  
✅ Android  
✅ Web  
✅ macOS  
✅ Windows  
✅ Linux  

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting PRs.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Author

Created by [definev](https://github.com/definev)

---

**Happy Routing! 🧘**
