part of '../../coordinator.dart';

class Search extends HomeShell with RouteBuilder {
  @override
  Uri? toUri() => Uri.parse('/search');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return SearchPage();
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Page')),
      body: const Center(child: Text('Search Page')),
    );
  }
}
