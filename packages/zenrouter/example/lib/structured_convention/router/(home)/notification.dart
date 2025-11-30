part of '../../coordinator.dart';

class Notification extends HomeShell with RouteBuilder {
  @override
  Uri? toUri() => Uri.parse('/notification');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return NotificationPage();
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Page')),
      body: const Center(child: Text('Notification Page')),
    );
  }
}
