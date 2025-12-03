part of '../../coordinator.dart';

/// Products layout - provides navigation structure for /products/*
///
/// File: routes/products/+layout.dart
/// Convention: +layout.dart files define RouteLayout for their directory
class ProductsLayout extends AppRoute with RouteLayout {
  @override
  NavigationPath<AppRoute> resolvePath(AppCoordinator coordinator) =>
      coordinator.productsStack;

  @override
  Uri toUri() => Uri.parse('/products');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => coordinator.pop(),
        ),
      ),
      body: RouteLayout.layoutBuilderTable[RouteLayout.navigationPath]!(
        coordinator,
        resolvePath(coordinator),
        this,
      ),
    );
  }
}
