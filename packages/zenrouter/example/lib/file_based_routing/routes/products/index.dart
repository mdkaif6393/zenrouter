part of '../../coordinator.dart';

/// Products index route
///
/// File: routes/products/index.dart
/// URL: /products
/// Convention: index.dart represents the default route for the directory
class ProductsIndexRoute extends AppRoute {
  @override
  RouteLayout? get layout => ProductsLayout.instance;

  @override
  Uri toUri() => Uri.parse('/products');

  @override
  Widget build(covariant Coordinator coordinator, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Products',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        _buildProductCard(
          context,
          coordinator,
          'Product 1',
          'A great product',
          '1',
        ),
        const SizedBox(height: 16),

        _buildProductCard(
          context,
          coordinator,
          'Product 2',
          'Another great product',
          '2',
        ),
        const SizedBox(height: 16),

        _buildProductCard(
          context,
          coordinator,
          'Product 3',
          'The best product',
          '3',
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Coordinator coordinator,
    String name,
    String description,
    String id,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.shopping_bag),
        title: Text(name),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => coordinator.push(ProductDetailRoute(id: id)),
      ),
    );
  }
}
