# File-Based Routing Example

This example demonstrates a **file-system-based routing convention** for the Coordinator paradigm, similar to Next.js or SvelteKit, with a strict separation between layouts and routes.

## Running the Example

```bash
# From packages/zenrouter/example directory
flutter run -t lib/file_based_routing/main.dart

# Or from the root of the repo
cd packages/zenrouter/example
flutter run -t lib/file_based_routing/main.dart
```

## Convention Overview

### File Naming

- **`routename.dart`** - Standalone route (e.g., `home.dart` → `/home`)
- **`index.dart`** - Default route for a directory (e.g., `products/index.dart` → `/products`)
- **`:parameter.dart`** - Route with path parameter (e.g., `:id.dart` → `/products/:id`)
- **`+layout.dart`** - Layout layout for routes in that directory
- **`subfolder/route.dart`** - Nested route under a layout

### Directory Structure = URL Structure

```
routes/
├── home.dart                      → /home (standalone route)
├── products/
│   ├── +layout.dart               → Layout for /products/* routes
│   ├── index.dart                 → /products (default route, layouted by ProductsLayout)
│   └── :id.dart                   → /products/:id (layouted by ProductsLayout)
└── settings/
    ├── +layout.dart               → Layout for /settings/* routes
    ├── index.dart                 → /settings (default route, layouted by SettingsLayout)
    ├── account.dart               → /settings/account (layouted by SettingsLayout)
    ├── privacy.dart               → /settings/privacy (layouted by SettingsLayout)
```

## URL Mapping

| File Path | URL | Route Class | Layout? |
|-----------|-----|-------------|---------|
| `home.dart` | `/home` | `HomeRoute` | No |
| `products/index.dart` | `/products` | `ProductsIndexRoute` | ProductsLayout |
| `products/:id.dart` | `/products/123` | `ProductDetailRoute(id: '123')` | ProductsLayout |
| `settings/index.dart` | `/settings` | `SettingsIndexRoute` | SettingsLayout |
| `settings/account.dart` | `/settings/account` | `SettingsAccountRoute` | SettingsLayout |
| `settings/privacy.dart` | `/settings/privacy` | `SettingsPrivacyRoute` | SettingsLayout |

## Implementation Details

### 1. Base Route Class

All routes must extend a base class that implements `RouteTarget` and mixes in `RouteUnique`.

```dart
// coordinator.dart
abstract class AppRoute extends RouteTarget with RouteUnique {}
```

### 2. Layout Implementation (`+layout.dart`)

Layouts are special routes that mix in `RouteLayout`. They are responsible for wrapping their child routes.

**Key Requirements:**
1.  Mixin `RouteLayout`.
2.  Override `resolvePath` to return the `NavigationPath` that this layout manages.
3.  In `build`, use `RouteLayout.layoutBuilderTable[RouteLayout.navigationPath]!` to render the nested content.

```dart
// routes/products/+layout.dart
class ProductsLayout extends AppRoute with RouteLayout {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.productsStack;

  @override
  Uri toUri() => Uri.parse('/products');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      // Render the nested route content
      body: RouteLayout.buildPrimitivePath(
        NavigationPath,
        coordinator,
        resolvePath(coordinator),
        this,
      ),
    );
  }
}
```

### 3. Route Implementation

Routes that belong to a layout must override the `layout` getter.

```dart
// routes/products/index.dart
class ProductsIndexRoute extends AppRoute {
  @override
  Type get layout => ProductsLayout; // Specify the layout class

  @override
  Uri toUri() => Uri.parse('/products');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return const Text('Products List');
  }
}
```

### 4. Coordinator Setup

The Coordinator manages the navigation stacks and registers layouts.

```dart
// coordinator.dart
class AppCoordinator extends Coordinator<AppRoute> with CoordinatorDebug {
  // Define navigation stacks
  final homeStack = NavigationPath<AppRoute>('home');
  final productsStack = NavigationPath<AppRoute>('products');
  final settingsStack = NavigationPath<AppRoute>('settings');

  @override
  List<StackPath> get paths => [root, homeStack, productsStack, settingsStack];

  @override
  void defineLayout() {
    // Register layout constructors
    RouteLayout.layoutConstructorTable[ProductsLayout] = ProductsLayout.new;
    RouteLayout.layoutConstructorTable[SettingsLayout] = SettingsLayout.new;
  }

  @override
  AppRoute parseRouteFromUri(Uri uri) {
    // Map URLs to routes...
  }
}
```

## When to Use Layouts

Use `+layout.dart` when you need to:
- Share UI structure (app bar, navigation) across multiple routes
- Maintain separate navigation stacks for a section
- Group related routes together

**Don't use layouts for**:
- Single standalone pages (use simple `.dart` files)
- Routes that don't share structure

## Benefits

✅ **Clear Separation** - Layouts vs standalone routes are visually distinct
✅ **No Ambiguity** - Can't accidentally navigate to a layout
✅ **Intuitive** - File structure clearly shows route hierarchy
✅ **Type-Safe** - Path parameters are typed
✅ **Code Generation Ready** - Structure enables automatic route generation

## Key Files

- **[main.dart](main.dart)** - Application entry point
- **[coordinator.dart](coordinator.dart)** - URL parsing and route mapping
- **[routes/](routes/)** - All route files following the convention

## See Also

- [Coordinator Pattern Guide](../../../doc/paradigms/coordinator.md)
- [Coordinator API Reference](../../../doc/api/coordinator.md)
