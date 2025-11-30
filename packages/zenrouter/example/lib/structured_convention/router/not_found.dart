part of '../coordinator.dart';

class NotFound extends AppRoute with RouteBuilder {
  NotFound(this.uri);

  final Uri uri;

  @override
  Uri? toUri() => Uri.parse('/not-found');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return NotFoundPage(uri: uri);
  }

  @override
  operator ==(Object other) {
    if (!equals(other)) return false;
    return other is NotFound && other.uri == uri;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, uri);
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Not Found route at: $uri')));
  }
}
