part of '../../coordinator.dart';

class Register extends AppRoute with RouteBuilder {
  @override
  Uri? toUri() => Uri.parse('/register');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return RegisterPage();
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Page')),
      body: const Center(child: Text('Register Page')),
    );
  }
}
