# Route Mixin System

> **Compose route behavior with mixins**

ZenRouter uses a mixin-based architecture that lets you add specific behaviors to your routes. Instead of a deep inheritance hierarchy, you compose functionality by mixing in exactly what you need.

## Overview

```dart
class MyRoute extends RouteTarget    // Base class (required)
    with RouteUnique                 // For coordinator (optional)
    with RouteGuard                  // Prevent navigation (optional)
    with RouteRedirect               // Conditional routing (optional)
    with RouteDeepLink {             // Custom deep link handling (optional)
  // Your route implementation
}
```

Each mixin adds specific capabilities:
- **RouteUnique** - Makes route work with Coordinator
- **RouteLayout** - Creates navigation host for nested routes
- **RouteTransition** - Custom page transitions
- **RouteGuard** - Prevents unwanted navigation
- **RouteRedirect** - Redirects to different routes
- **RouteDeepLink** - Custom deep link handling

## Mixin Reference

### RouteUnique

Makes a route identifiable by `Coordinator` and provides URI mapping.

**Required when:**
- Using the Coordinator pattern
- You need deep linking support
- You want URL synchronization

**Not needed when:**
- Using pure imperative navigation
- Using pure declarative navigation without Coordinator

#### API

```dart
mixin RouteUnique on RouteTarget {
  // Convert route to URI
  Uri toUri();
  
  // Build the UI for this route
  Widget build(covariant Coordinator coordinator, BuildContext context);
  
  // Optional: Parent layout Type
  Type? get layout => null;
  
  // Create a new layout instance (called automatically)
  RouteLayout? createLayout(covariant Coordinator coordinator);
  
  // Resolve or create layout from active layouts (called automatically)
  RouteLayout? resolveLayout(covariant Coordinator coordinator);
}
```

#### Example

```dart
class HomeRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => coordinator.push(ProfileRoute()),
          child: const Text('Go to Profile'),
        ),
      ),
    );
  }
}

class ProfileRoute extends RouteTarget with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/profile');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page')),
    );
  }
}
```

#### With Parameters

```dart
class UserRoute extends RouteTarget with RouteUnique {
  final String userId;
  
  UserRoute(this.userId);
  
  @override
  Uri toUri() => Uri.parse('/user/$userId');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User: $userId')),
      body: UserProfile(userId: userId),
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (!compareWith(other)) return false;
    return other is UserRoute && other.userId == userId;
  }
  
  @override
  int get hashCode => Object.hash(super.hashCode, userId);
}
```

---

### RouteLayout<T>

Creates a navigation host that contains and manages other routes. Essential for nested navigation.

**Use when:**
- Creating tab bar containers
- Building drawer navigation
- Managing nested navigation stacks
- Creating shell routes

**Types of hosts:**
- **DynamicNavigationPath host** - Stack-based navigation (push/pop)
- **FixedNavigationPath host** - Indexed navigation (tabs, drawers)

#### API

```dart
mixin RouteLayout<T extends RouteUnique> on RouteUnique {
  // Which navigation path does this layout manage?
  StackPath<RouteUnique> resolvePath(covariant Coordinator coordinator);
  
  // Builds the layout UI (automatically delegates to layoutBuilderTable)
  @override
  Widget build(covariant Coordinator coordinator, BuildContext context);
  
  // Optional: Parent layout Type (for nested layouts)
  @override
  Type? get layout => null;
  
  // Static tables for layout construction and building
  static Map<Type, RouteLayoutConstructor> layoutConstructorTable = {};
  static Map<String, RouteLayoutBuilder> layoutBuilderTable = {...};
  
  // Register a layout constructor
  static void defineLayout<T extends RouteLayout>(
    Type layoutType,
    T Function() constructor,
  );
}
```

#### Example: Tab Bar Layout (Indexed Navigation)

```dart
class TabBarLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  IndexedStackPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.tabPath;
  
  @override
  Uri toUri() => Uri.parse('/tabs');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    final path = coordinator.tabPath;
    
    return Scaffold(
      body: RouteLayout.layoutBuilderTable[RouteLayout.indexedStackPath]!(
        coordinator,
        path,
        this,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: path.activePathIndex,
        onTap: (index) => switch (index) {
          0 => coordinator.push(FeedTab()),
          1 => coordinator.push(ProfileTab()),
          2 => coordinator.push(SettingsTab()),
          _ => null,
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// Tab routes point to the tab layout using Type reference
class FeedTab extends AppRoute {
  @override
  Type? get layout => TabBarLayout;
  
  @override
  Uri toUri() => Uri.parse('/tabs/feed');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return const Center(child: Text('Feed Tab'));
  }
}

// Register layout in Coordinator
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  void defineLayout() {
    RouteLayout.defineLayout(TabBarLayout, () => TabBarLayout());
  }
}
```

#### Example: Stack Navigation Layout (Dynamic Navigation)

```dart
class SettingsLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.settingsStack;
  
  @override
  Uri toUri() => Uri.parse('/settings');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RouteLayout.layoutBuilderTable[RouteLayout.navigationPath]!(
        coordinator,
        coordinator.settingsStack,
        this,
      ),
    );
  }
  
  @override
  bool operator ==(Object other) => other is SettingsLayout;
  
  @override
  int get hashCode => runtimeType.hashCode;
}

// Settings routes point to settings layout using Type reference
class GeneralSettings extends AppRoute {
  @override
  Type? get layout => SettingsLayout;
  
  @override
  Uri toUri() => Uri.parse('/settings/general');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Account'),
          onTap: () => coordinator.push(AccountSettings()),
        ),
        ListTile(
          title: const Text('Privacy'),
          onTap: () => coordinator.push(PrivacySettings()),
        ),
      ],
    );
  }
}

// Register layout in Coordinator
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  void defineLayout() {
    RouteLayout.defineLayout(SettingsLayout, () => SettingsLayout());
  }
}
```

#### Example: Nested Layouts

```dart
// Level 1: Main app layout
class AppLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.mainStack;
  
  @override
  Uri toUri() => Uri.parse('/');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      body: RouteLayout.layoutBuilderTable[RouteLayout.navigationPath]!(
        coordinator,
        coordinator.mainStack,
        this,
      ),
    );
  }
}

// Level 2: Tab bar layout (nested inside AppLayout)
class TabBarLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  Type? get layout => AppLayout; // Parent layout Type
  
  @override
  IndexedStackPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.tabPath;
  
  @override
  Uri toUri() => Uri.parse('/tabs');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      body: RouteLayout.layoutBuilderTable[RouteLayout.indexedStackPath]!(
        coordinator,
        coordinator.tabPath,
        this,
      ),
      bottomNavigationBar: BottomNavigationBar(/* ... */),
    );
  }
}

// Level 3: Feed stack layout (nested inside TabBarLayout)
class FeedLayout extends AppRoute with RouteLayout<AppRoute> {
  @override
  Type? get layout => TabBarLayout; // Parent layout Type
  
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.feedStack;
  
  @override
  Uri toUri() => Uri.parse('/tabs/feed');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return RouteLayout.layoutBuilderTable[RouteLayout.navigationPath]!(
      coordinator,
      coordinator.feedStack,
      this,
    );
  }
}

// Register all layouts in Coordinator
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  void defineLayout() {
    RouteLayout.defineLayout(AppLayout, () => AppLayout());
    RouteLayout.defineLayout(TabBarLayout, () => TabBarLayout());
    RouteLayout.defineLayout(FeedLayout, () => FeedLayout());
  }
}
```

---

### RouteGuard

Prevents navigation away from a route unless certain conditions are met. Perfect for unsaved changes warnings.

**Use when:**
- Forms have unsaved changes
- Processes shouldn't be interrupted
- You need confirmation before leaving

#### API

```dart
mixin RouteGuard on RouteTarget {
  // Return true to allow pop, false to prevent
  FutureOr<bool> popGuard();
}
```

#### Example: Unsaved Changes Warning

```dart
class EditFormRoute extends RouteTarget with RouteUnique, RouteGuard {
  bool hasUnsavedChanges = false;
  
  @override
  Future<bool> popGuard() async {
    if (!hasUnsavedChanges) return true; // No changes, allow pop
    
    // Show confirmation dialog
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. Discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    
    return shouldPop ?? false;
  }
  
  @override
  Uri toUri() => Uri.parse('/edit');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Guard is automatically checked
            coordinator.pop();
          },
        ),
      ),
      body: TextField(
        onChanged: (value) => hasUnsavedChanges = true,
        decoration: const InputDecoration(
          hintText: 'Start typing...',
        ),
      ),
    );
  }
}
```

#### Example: Process Confirmation

```dart
class UploadRoute extends RouteTarget with RouteGuard {
  bool isUploading = false;
  
  @override
  Future<bool> popGuard() async {
    if (!isUploading) return true;
    
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload in Progress'),
        content: const Text('Cancel upload and go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue Upload'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel Upload'),
          ),
        ],
      ),
    );
    
    if (shouldCancel == true) {
      // Cancel the upload
      uploadTask.cancel();
    }
    
    return shouldCancel ?? false;
  }
}
```

---

### RouteRedirect<T>

Redirects navigation to a different route based on conditions. Perfect for authentication flows and conditional routing.

**Use when:**
- Checking authentication state
- Enforcing permissions
- Conditional routing based on data
- A/B testing different flows

#### API

```dart
mixin RouteRedirect<T extends RouteTarget> on RouteTarget {
  // Return the route to navigate to (can be async)
  // Return this to stay on current route
  // Return null to prevent navigation
  FutureOr<T?> redirect();
}
```

#### Example: Authentication Check

```dart
class DashboardRoute extends RouteTarget 
    with RouteUnique, RouteRedirect<AppRoute> {
  @override
  Future<AppRoute?> redirect() async {
    final isLoggedIn = await authService.checkAuth();
    
    if (!isLoggedIn) {
      // Redirect to login
      return LoginRoute(redirectTo: '/dashboard');
    }
    
    // Stay on dashboard
    return this;
  }
  
  @override
  Uri toUri() => Uri.parse('/dashboard');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Welcome to Dashboard!')),
    );
  }
}

class LoginRoute extends RouteTarget with RouteUnique {
  final String? redirectTo;
  
  LoginRoute({this.redirectTo});
  
  @override
  Uri toUri() => Uri.parse('/login');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authService.login();
            if (redirectTo != null) {
              coordinator.recoverRouteFromUri(Uri.parse(redirectTo!));
            } else {
              coordinator.replace(DashboardRoute());
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
```

#### Example: Permission Check

```dart
class AdminRoute extends RouteTarget with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute?> redirect() async {
    final user = await authService.getCurrentUser();
    
    if (user == null) {
      return LoginRoute(redirectTo: '/admin');
    }
    
    if (!user.isAdmin) {
      return UnauthorizedRoute();
    }
    
    return this; // User is admin, allow access
  }
}
```

#### Example: Data-Driven Redirect

```dart
class PostRoute extends RouteTarget with RouteRedirect<AppRoute> {
  final String postId;
  
  PostRoute(this.postId);
  
  @override
  Future<AppRoute?> redirect() async {
    final post = await postService.getPost(postId);
    
    if (post == null) {
      return NotFoundRoute();
    }
    
    if (post.isDeleted) {
      return DeletedPostRoute(postId);
    }
    
    if (post.requiresSubscription && !user.hasSubscription) {
      return SubscriptionRequiredRoute();
    }
    
    return this;
  }
}
```

#### Redirect Chains

Redirects can chain together - each redirect is followed until a non-redirecting route is reached:

```dart
// RouteA redirects to RouteB
class RouteA extends RouteTarget with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async => RouteB();
}

// RouteB redirects to RouteC
class RouteB extends RouteTarget with RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async => RouteC();
}

// RouteC doesn't redirect
class RouteC extends RouteTarget {}

// Pushing RouteA ends up at RouteC!
coordinator.push(RouteA());
// Internal flow: RouteA → RouteB → RouteC
```

---

### RouteDeepLink

Provides custom handling for deep links beyond the default strategies.

**Use when:**
- Deep link requires multi-step navigation setup
- You need to track analytics for deep links
- Deep link needs to load data first
- Custom navigation flow for deep links

#### API

```dart
mixin RouteDeepLink on RouteUnique {
  // Strategy for handling deep links
  DeeplinkStrategy get deeplinkStrategy;
  
  // Custom deep link handler (only called if strategy is custom)
  FutureOr<void> deeplinkHandler(
    covariant Coordinator coordinator,
    Uri uri,
  );
}

enum DeeplinkStrategy {
  replace,  // Replace entire stack with this route (default)
  push,     // Push onto current stack
  custom,   // Use deeplinkHandler()
}
```

#### Example: Multi-Step Deep Link Setup

```dart
class ProductDetailRoute extends RouteTarget 
    with RouteUnique, RouteDeepLink {
  final String productId;
  
  ProductDetailRoute(this.productId);
  
  @override
  Uri toUri() => Uri.parse('/product/$productId');
  
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.custom;
  
  @override
  Future<void> deeplinkHandler(
    AppCoordinator coordinator,
    Uri uri,
  ) async {
    // 1. Ensure correct tab is active
    coordinator.replace(ShopTab());
    
    // 2. Load product data
    final product = await productService.loadProduct(productId);
    
    // 3. Set up category first
    if (product.category != null) {
      coordinator.push(CategoryRoute(product.category!));
    }
    
    // 4. Navigate to product
    coordinator.push(this);
    
    // 5. Track analytics
    analytics.logDeepLink(uri, {
      'product_id': productId,
      'source': uri.queryParameters['source'],
    });
  }
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $productId')),
      body: ProductDetailView(productId: productId),
    );
  }
}
```

#### Example: Push Strategy

```dart
class ModalRoute extends RouteTarget with RouteUnique, RouteDeepLink {
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.push;
  
  @override
  Uri toUri() => Uri.parse('/modal');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: const Text('Modal from deep link'),
      ),
    );
  }
}

// Deep link: myapp://modal
// Result: Pushed on top of existing stack
```

#### Example: Analytics Tracking

```dart
class CampaignRoute extends RouteTarget with RouteDeepLink {
  final String campaignId;
  
  CampaignRoute(this.campaignId);
  
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.custom;
  
  @override
  Future<void> deeplinkHandler(
    AppCoordinator coordinator,
    Uri uri,
  ) async {
    // Track campaign parameters
    final source = uri.queryParameters['utm_source'];
    final medium = uri.queryParameters['utm_medium'];
    final campaign = uri.queryParameters['utm_campaign'];
    
    analytics.logEvent('campaign_opened', {
      'campaign_id': campaignId,
      'source': source,
      'medium': medium,
      'campaign': campaign,
    });
    
    // Load campaign data
    final data = await campaignService.load(campaignId);
    
    // Navigate to appropriate screen
    if (data.type == 'product') {
      coordinator.replace(ProductRoute(data.productId));
    } else {
      coordinator.replace(CampaignDetailRoute(campaignId));
    }
  }
}
```

---

### RouteTransition

Customizes page transition animations for a route.

**Use when:**
- You want custom page transitions
- Different routes need different transitions
- Platform-specific transitions

#### API

```dart
mixin RouteTransition on RouteUnique {
  StackTransition<T> transition<T extends RouteUnique>(
    covariant Coordinator coordinator,
  );
}
```

#### Example: Custom Transition

```dart
class FadeRoute extends RouteTarget with RouteUnique, RouteTransition {
  @override
  Uri toUri() => Uri.parse('/fade');
  
  @override
  StackTransition<T> transition<T extends RouteUnique>(
    Coordinator coordinator,
  ) {
    return StackTransition.custom(
      builder: (context) => build(coordinator, context),
      pageBuilder: (context, key, child) => PageRouteBuilder(
        settings: RouteSettings(name: key.toString()),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fade Transition')),
      body: const Center(child: Text('Faded in!')),
    );
  }
}
```

#### Example: Platform-Specific Transitions

```dart
class AdaptiveRoute extends RouteTarget with RouteTransition {
  @override
  StackTransition<T> transition<T extends RouteUnique>(
    Coordinator coordinator,
  ) {
    if (Platform.isIOS) {
      return StackTransition.cupertino(
        build(coordinator, coordinator.navigator.context),
      );
    } else {
      return StackTransition.material(
        build(coordinator, coordinator.navigator.context),
      );
    }
  }
}
```

---

## Mixin Combinations

### Common Patterns

#### Simple Page
```dart
class SimplePage extends AppRoute with RouteUnique {
  @override
  Uri toUri() => Uri.parse('/simple');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Page')),
      body: const Center(child: Text('Hello!')),
    );
  }
}
```

#### Guarded Form
```dart
class FormPage extends AppRoute with RouteUnique, RouteGuard {
  bool hasUnsavedChanges = false;
  
  @override
  Future<bool> popGuard() async {
    if (!hasUnsavedChanges) return true;
    return await confirmDiscard(context);
  }
  
  @override
  Uri toUri() => Uri.parse('/form');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return FormScreen(
      onChanged: () => hasUnsavedChanges = true,
    );
  }
}
```

#### Protected Route with Redirect
```dart
class ProtectedRoute extends AppRoute 
    with RouteUnique, RouteRedirect<AppRoute> {
  @override
  Future<AppRoute> redirect() async {
    final isAuthed = await auth.check();
    return isAuthed ? this : LoginRoute();
  }
  
  @override
  Uri toUri() => Uri.parse('/protected');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return const ProtectedContent();
  }
}
```

#### Deep Link with Analytics
```dart
class TrackedRoute extends AppRoute with RouteUnique, RouteDeepLink {
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.custom;
  
  @override
  Future<void> deeplinkHandler(Coordinator coordinator, Uri uri) async {
    analytics.logDeepLink(uri);
    coordinator.replace(this);
  }
  
  @override
  Uri toUri() => Uri.parse('/tracked');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return const TrackedScreen();
  }
}
```

#### Everything Together
```dart
class ComplexRoute extends AppRoute
    with RouteUnique, RouteGuard, RouteRedirect, RouteDeepLink {
  bool isDirty = false;
  
  @override
  Future<bool> popGuard() async => !isDirty || await confirmExit();
  
  @override
  Future<AppRoute?> redirect() async {
    if (!await auth.check()) return LoginRoute();
    return this;
  }
  
  @override
  DeeplinkStrategy get deeplinkStrategy => DeeplinkStrategy.custom;
  
  @override
  Future<void> deeplinkHandler(Coordinator coordinator, Uri uri) async {
    analytics.log(uri);
    await setupNavigationStack(coordinator);
    coordinator.push(this);
  }
  
  @override
  Uri toUri() => Uri.parse('/complex');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ComplexScreen(onChanged: () => isDirty = true);
  }
}
```

## Decision Tree

```
Which mixins do I need?
│
├─ Using Coordinator?
│  ├─ Yes → Add RouteUnique ✓
│  └─ No → Just extend RouteTarget
│
├─ Creating a navigation host (tabs, shells)?
│  ├─ Yes → Add RouteLayout ✓
│  └─ No → Continue
│
├─ Need custom page transitions?
│  ├─ Yes → Add RouteTransition ✓
│  └─ No → Continue
│
├─ Prevent navigation (unsaved changes)?
│  ├─ Yes → Add RouteGuard ✓
│  └─ No → Continue
│
├─ Conditional routing (auth, permissions)?
│  ├─ Yes → Add RouteRedirect ✓
│  └─ No → Continue
│
└─ Custom deep link handling?
   ├─ Yes → Add RouteDeepLink ✓
   └─ No → Done!
```

## Best Practices

### ✅ DO: Use Minimal Mixins

Only add mixins you actually need:

```dart
// ✅ GOOD: Only what's needed
class SimpleRoute extends RouteTarget with RouteUnique {
  // Just basic coordinator support
}

// ❌ BAD: Unnecessary mixins
class SimpleRoute extends RouteTarget 
    with RouteUnique, RouteGuard, RouteRedirect {
  @override
  Future<bool> popGuard() => true; // Always true = useless
  
  @override
  Future<AppRoute> redirect() => this; // Always this = useless
}
```

### ✅ DO: Combine Related Mixins

Guards and redirects work well together:

```dart
class SecureFormRoute extends AppRoute 
    with RouteUnique, RouteGuard, RouteRedirect {
  bool hasChanges = false;
  
  // Redirect: Check auth first
  @override
  Future<AppRoute> redirect() async {
    return await auth.check() ? this : LoginRoute();
  }
  
  // Guard: Prevent accidental exit
  @override
  Future<bool> popGuard() async {
    return !hasChanges || await confirmDiscard();
  }
}
```

### ❌ DON'T: Create Deep Inheritance Hierarchies

Use composition, not inheritance:

```dart
// ❌ BAD: Deep hierarchy
abstract class AuthenticatedRoute extends AppRoute with RouteRedirect {...}
abstract class GuardedRoute extends AuthenticatedRoute with RouteGuard {...}
class MyRoute extends GuardedRoute {...}

// ✅ GOOD: Flat composition
class MyRoute extends AppRoute 
    with RouteUnique, RouteRedirect, RouteGuard {
  // All mixins at once, clear and explicit
}
```

### ❌ DON'T: Use RouteLayout Without Coordinator

`RouteLayout` requires `Coordinator`:

```dart
// ❌ BAD: RouteLayout without coordinator
class TabHost extends RouteTarget with RouteLayout {...}
// Won't work with pure imperative/declarative navigation

// ✅ GOOD: Use RouteUnique with RouteLayout
class TabHost extends RouteTarget with RouteUnique, RouteLayout {...}
// Works with Coordinator
```

## See Also

- [Imperative Navigation](../paradigms/imperative.md) - Using mixins with imperative navigation
- [Coordinator Pattern](../paradigms/coordinator.md) - Using mixins with coordinator
- [API Reference](../api/core-classes.md) - Detailed API documentation
