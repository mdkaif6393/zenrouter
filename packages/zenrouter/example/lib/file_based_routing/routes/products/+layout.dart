part of '../../coordinator.dart';

/// Products layout - provides navigation structure for /products/*
///
/// File: routes/products/+layout.dart
/// Convention: +layout.dart files define RouteLayout for their directory
class ProductsLayout extends AppRoute with RouteLayout {
  ProductsLayout._();
  static final instance = ProductsLayout._();

  @override
  DynamicNavigationPath resolvePath(covariant Coordinator coordinator) {
    final appCoordinator = coordinator as AppCoordinator;
    return appCoordinator.productsStack;
  }

  @override
  Uri toUri() => Uri.parse('/products');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    final appCoordinator = coordinator as AppCoordinator;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => coordinator.pop(),
        ),
      ),
      body: RouteLayout.defaultBuildForDynamicPath(
        coordinator,
        appCoordinator.productsStack,
      ),
    );
  }
}
