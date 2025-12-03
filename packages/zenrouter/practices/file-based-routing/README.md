# File-Based Routing Convention

This practice demonstrates a **file-system-based routing convention** for the Coordinator paradigm, similar to Next.js or SvelteKit.

## Convention Overview

### File Naming

- **`index.dart`** - Route at the directory path
- **`:parameter.dart`** - Route with path parameter
- **`+layout.dart`** - Layout host for the directory

### Directory Structure = URL Structure

The file system structure directly maps to URL paths:

```
routes/
├── home/
│   ├── +layout.dart          → Layout for /home/*
│   └── index.dart            → /home
├── products/
│   ├── +layout.dart          → Layout for /products/*
│   ├── index.dart            → /products
│   ├── :id.dart              → /products/:id
│   └── :id/
│       ├── reviews.dart      → /products/:id/reviews
│       └── specs.dart        → /products/:id/specs
└── settings/
    ├── +layout.dart          → Layout for /settings/*
    ├── index.dart            → /settings
    ├── account.dart          → /settings/account
    └── privacy.dart          → /settings/privacy
```

## Example: E-Commerce App

This example shows a complete e-commerce app structure with:
- Home page
- Product listing and details
- Settings pages
- Nested navigation

### File Structure

```
file-based-routing/
├── README.md (this file)
├── routes/
│   ├── home/
│   │   ├── +layout.dart
│   │   └── index.dart
│   ├── products/
│   │   ├── +layout.dart
│   │   ├── index.dart
│   │   └── :id.dart
│   └── settings/
│       ├── +layout.dart
│       ├── index.dart
│       ├── account.dart
│       └── privacy.dart
└── coordinator.dart
```

### URL Mapping

| File Path | URL | Route Class |
|-----------|-----|-------------|
| `home/index.dart` | `/home` | `HomeRoute` |
| `products/index.dart` | `/products` | `ProductsRoute` |
| `products/:id.dart` | `/products/123` | `ProductDetailRoute(id: '123')` |
| `settings/index.dart` | `/settings` | `SettingsRoute` |
| `settings/account.dart` | `/settings/account` | `SettingsAccountRoute` |
| `settings/privacy.dart` | `/settings/privacy` | `SettingsPrivacyRoute` |

## Benefits

✅ **Intuitive** - URL structure mirrors file structure  
✅ **Organized** - Related routes grouped together  
✅ **Scalable** - Easy to add new routes  
✅ **Type-Safe** - Path parameters are typed  
✅ **Code Generation Ready** - Structure enables automatic route generation  

## Usage

### 1. Define Routes with File Convention

Each file exports a route class:

```dart
// routes/products/index.dart
class ProductsRoute extends AppRoute {
  @override
  Uri toUri() => Uri.parse('/products');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ProductsScreen();
  }
}
```

### 2. Create Layouts with `+layout.dart`

Layout files define navigation hosts:

```dart
// routes/products/+layout.dart
class ProductsLayout extends AppRoute with RouteLayout {
  static final instance = ProductsLayout();
  
  @override
  DynamicNavigationPath resolvePath(AppCoordinator coordinator) =>
      coordinator.productsStack;
  
  @override
  Uri toUri() => Uri.parse('/products');
  
  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: RouteLayout.defaultBuildForDynamicPath(
        coordinator,
        coordinator.productsStack,
      ),
    );
  }
}
```

### 3. Handle Parameters with `:parameter.dart`

Parameter files accept typed parameters:

```dart
// routes/products/:id.dart
class ProductDetailRoute extends AppRoute {
  final String id;
  
  ProductDetailRoute({required this.id});
  
  @override
  RouteLayout? get layout => ProductsLayout.instance;
  
  @override
  Uri toUri() => Uri.parse('/products/$id');
  
  @override
  Widget build(Coordinator coordinator, BuildContext context) {
    return ProductDetailScreen(productId: id);
  }
  
  @override
  bool operator ==(Object other) {
    if (!compareWith(other)) return false;
    return other is ProductDetailRoute && other.id == id;
  }
  
  @override
  int get hashCode => Object.hash(super.hashCode, id);
}
```

### 4. Parse URLs in Coordinator

The coordinator maps URLs to routes based on file structure:

```dart
class AppCoordinator extends Coordinator<AppRoute> {
  @override
  AppRoute parseRouteFromUri(Uri uri) {
    return switch (uri.pathSegments) {
      // home/index.dart
      ['home'] => HomeRoute(),
      
      // products/index.dart
      ['products'] => ProductsRoute(),
      
      // products/:id.dart
      ['products', final id] => ProductDetailRoute(id: id),
      
      // settings/index.dart
      ['settings'] => SettingsRoute(),
      
      // settings/account.dart
      ['settings', 'account'] => SettingsAccountRoute(),
      
      // settings/privacy.dart
      ['settings', 'privacy'] => SettingsPrivacyRoute(),
      
      _ => HomeRoute(),
    };
  }
}
```

## Code Generation Potential

This convention enables **automatic route generation**:

```dart
// Generated code (future)
abstract class Routes {
  static HomeRoute get home => HomeRoute();
  static ProductsRoute get products => ProductsRoute();
  static ProductDetailRoute productDetail(String id) => ProductDetailRoute(id: id);
  static SettingsRoute get settings => SettingsRoute();
  static SettingsAccountRoute get settingsAccount => SettingsAccountRoute();
  static SettingsPrivacyRoute get settingsPrivacy => SettingsPrivacyRoute();
}

// Usage
coordinator.push(Routes.productDetail('123'));
```

## Advanced Patterns

### Multiple Parameters

```
routes/
└── users/
    └── :userId/
        └── posts/
            └── :postId.dart  → /users/:userId/posts/:postId
```

```dart
class UserPostRoute extends AppRoute {
  final String userId;
  final String postId;
  
  UserPostRoute({required this.userId, required this.postId});
  
  @override
  Uri toUri() => Uri.parse('/users/$userId/posts/$postId');
}
```

### Optional Segments

```
routes/
└── products/
    ├── index.dart              → /products
    └── category/
        └── :category?.dart     → /products/category (optional)
```

### Catch-All Routes

```
routes/
└── docs/
    └── [...path].dart          → /docs/* (catch all)
```

## See Also

- [Coordinator Pattern Guide](../../docs/paradigms/coordinator.md)
- [Coordinator API Reference](../../docs/api/coordinator.md)
- [Complete Example](./routes/) - Full working example

## Next Steps

1. Explore the example routes
2. Run the example app
3. Try adding new routes following the convention
4. Consider building a code generator for your project
