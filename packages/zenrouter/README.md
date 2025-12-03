# ZenRouter 🧘

**The Ultimate Flutter Router for Every Navigation Pattern**

ZenRouter is the only router you'll ever need - supporting three distinct paradigms to handle any routing scenario. From simple mobile apps to complex web applications with deep linking, ZenRouter adapts to your needs.

---

## Why ZenRouter?

**One router. Three paradigms. Infinite possibilities.**

✨ **Three Paradigms in One** - Choose imperative, declarative, or coordinator based on your needs  
🚀 **Start Simple, Scale Seamlessly** - Begin with basics, add complexity as you grow  
🌐 **Full Web & Deep Linking** - Built-in URL handling and browser navigation  
⚡ **Blazing Fast** - Efficient Myers diff algorithm for optimal performance  
🔒 **Type-Safe** - Catch routing errors at compile-time, not runtime  
🛡️ **Powerful Guards & Redirects** - Protect routes and control navigation flow  
📦 **Zero Boilerplate** - Clean, mixin-based architecture  
📝 **No Codegen Needed** - Pure Dart, no build_runner or generated files  

---

## Three Paradigms, Infinite Flexibility

### 🎮 **Imperative** - Direct Control
*Perfect for mobile apps and event-driven navigation*

```dart
final path = NavigationPath<AppRoute>();

// Push routes
path.push(ProfileRoute());

// Pop back
path.pop();

// That's it!
```

**When to use:**
- Mobile-only applications
- Button clicks and gesture-driven navigation
- Migrating from Navigator 1.0
- You want simple, direct control

[→ Learn Imperative Routing](docs/paradigms/imperative.md)

---

### 📊 **Declarative** - State-Driven
*Perfect for tab bars, filtered lists, and React-like UIs*

```dart
// Your state
List<int> pages = [1, 2, 3];

// Navigation automatically updates when state changes
NavigationStack.declarative(
  routes: [
    for (final page in pages) PageRoute(page),
  ],
  resolver: (route) => StackTransition.material(...),
)

// Add a page? Navigation updates automatically!
setState(() => pages.add(4));
```

**When to use:**
- Tab navigation
- Filtered or dynamic lists
- State-driven UIs
- React-like declarative patterns

[→ Learn Declarative Routing](docs/paradigms/declarative.md)

---

### 🗺️ **Coordinator** - Deep Linking & Web
*Perfect for web apps and complex navigation hierarchies*

```dart
// Define routes with URIs
class ProfileRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/profile');
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

// Now you have:
// ✅ myapp://profile opens ProfileRoute
// ✅ Website URLs work seamlessly
// ✅ Browser back button supported
```

**When to use:**
- Web applications
- Deep linking requirements
- Complex nested navigation
- URL synchronization needed

[→ Learn Coordinator Pattern](docs/paradigms/coordinator.md)

---

## Quick Comparison

|  | **Imperative** | **Declarative** | **Coordinator** |
|---|:---:|:---:|:---:|
| **Simplicity** | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Web Support** | ❌ | ❌ | ✅ |
| **Deep Linking** | ❌ | ❌ | ✅ |
| **State-Driven** | Compatible | ✅ Native | Compatible |
| **Best For** | Mobile apps | Tab bars, lists | Web, large apps |

---

## Getting Started

### Installation

```yaml dependencies:
  zenrouter: ^0.1.0
```

```bash
flutter pub get
```

### Quick Start - Pick Your Paradigm

#### Simple Mobile App? → Imperative

```dart
// 1. Create a path
final path = NavigationPath<RouteTarget>();

// 2. Render it
NavigationStack(
  path: path,
  defaultRoute: HomeRoute(),
  resolver: (route) => StackTransition.material(
    route.build(context),
  ),
)

// 3. Navigate!
path.push(ProfileRoute());
```

#### Tab Bar or List? → Declarative

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedTab = 0;
  
  @override
  Widget build(BuildContext context) {
    return NavigationStack.declarative(
      routes: [
        HomeRoute(),
        switch (selectedTab) {
          0 => FeedRoute(),
          1 => ProfileRoute(),
          2 => SettingsRoute(),
          _ => FeedRoute(),
        },
      ],
      resolver: (route) => StackTransition.material(...),
    );
  }
}
```

#### Web App? → Coordinator

```dart
// 1. Define routes with URIs
class HomeRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return HomeScreen();
  }
}

// 2. Create coordinator
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

// 3. Use MaterialApp.router
MaterialApp.router(
  routerDelegate: coordinator.routerDelegate,
  routeInformationParser: coordinator.routeInformationParser,
)
```

[→ Full Getting Started Guide](docs/guides/getting-started.md)

---

## Powerful Features

### 🛡️ Route Guards - Prevent Unwanted Navigation

```dart
class FormRoute extends RouteTarget with RouteGuard {
  bool hasUnsavedChanges = false;
  
  @override
  Future<bool> popGuard() async {
    if (!hasUnsavedChanges) return true;
    return await showConfirmDialog() ?? false;
  }
}
```

### 🔄 Route Redirects - Authentication & Authorization

```dart
class DashboardRoute extends RouteTarget with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async {
    final isLoggedIn = await auth.check();
    return isLoggedIn ? this : LoginRoute();
  }
}
```

### 🎨 Custom Transitions

```dart
resolver: (route) => switch (route) {
  HomeRoute() => StackTransition.material(HomeScreen()),
  ProfileRoute() => StackTransition.cupertino(ProfileScreen()),
  ModalRoute() => StackTransition.sheet(ModalContent()),
  DialogRoute() => StackTransition.dialog(DialogContent()),
  _ => StackTransition.material(NotFoundScreen()),
}
```

### 🏗️ Nested Navigation

```dart
class AppCoordinator extends Coordinator<AppRoute> {
  final mainNav = NavigationPath('main');
  final settingsNav = NavigationPath('settings');
  final tabNav = IndexedStackPath([Tab1(), Tab2(), Tab3()], 'tabs');
  
  @override
  List<StackPath> get paths => [root, mainNav, settingsNav, tabNav];
}
```

---

## Choose Your Path

```
Need web support or deep linking?
│
├─ YES → Use Coordinator
│        ✓ Deep linking & URL sync
│        ✓ Browser back button
│        ✓ Perfect for web apps
│
└─ NO → Is navigation driven by state?
       │
       ├─ YES → Use Declarative
       │        ✓ Efficient Myers diff
       │        ✓ React-like patterns
       │        ✓ Perfect for tab bars
       │
       └─ NO → Use Imperative
                ✓ Simple & direct
                ✓ Full control
                ✓ Perfect for mobile
```

---

## Documentation

### **📚 Guides**
- [Getting Started](docs/guides/getting-started.md) - Choose your paradigm and get started
- [Imperative Navigation](docs/paradigms/imperative.md) - Direct stack control
- [Declarative Navigation](docs/paradigms/declarative.md) - State-driven routing
- [Coordinator Pattern](docs/paradigms/coordinator.md) - Deep linking & web support

### **🔧 API Reference**
- [Route Mixins](docs/api/mixins.md) - Guards, redirects, transitions, and more
- [Navigation Paths](docs/api/navigation-paths.md) - Stack containers and navigation
- [Coordinator API](docs/api/coordinator.md) - Full coordinator reference
- [Core Classes](docs/api/core-classes.md) - RouteTarget and fundamentals

### **💡 Examples**
- [Imperative Example](example/lib/main_imperative.dart) - Multi-step form
- [Declarative Example](example/lib/main_declrative.dart) - State-driven navigation
- [Coordinator Example](example/lib/main_coordinator.dart) - Deep linking & nested navigation

---

## Migration Made Easy

### From Navigator 1.0

```dart
// Before (Navigator 1.0)
Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
Navigator.pop(context);

// After (ZenRouter Imperative)
path.push(ProfileRoute());
path.pop();
```

### From GoRouter / Navigator 2.0

```dart
// Before (GoRouter)
context.go('/profile');
context.push('/settings');

// After (ZenRouter Coordinator)
coordinator.replace(ProfileRoute());
coordinator.push(SettingsRoute());
```

---

## Platform Support

✅ **iOS** - Native page transitions  
✅ **Android** - Material design support  
✅ **Web** - Full URL and deep linking  
✅ **macOS** - Desktop navigation  
✅ **Windows** - Desktop navigation  
✅ **Linux** - Desktop navigation  

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

Apache 2.0 License - see [LICENSE](LICENSE) for details.

## Created With Love By

[definev](https://github.com/definev)

---

<div align="center">

**The Ultimate Router for Flutter**

[Documentation](docs/guides/getting-started.md) • [Examples](example/) • [Issues](https://github.com/definev/zenrouter/issues)

**Happy Routing! 🧘**

</div>
