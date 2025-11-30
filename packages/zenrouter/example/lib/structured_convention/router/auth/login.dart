part of '../../coordinator.dart';

class Login extends AppRoute with RouteBuilder, RouteRedirect {
  Login({this.redirectTo});

  final Uri? redirectTo;

  @override
  Uri? toUri() => Uri.parse('/auth/login').replace(
    queryParameters: {
      if (redirectTo != null) 'redirect': redirectTo!.toString(),
    },
  );

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return LoginPage(coordinator: coordinator, redirect: redirectTo);
  }

  @override
  FutureOr<AppRoute?> redirect() {
    if (authService.isAuthenticated) {
      final route = coordinator.parseRouteFromUri(redirectTo ?? Uri(path: '/'));
      coordinator.replace(route);
      return null;
    }

    return this;
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.redirect, required this.coordinator});

  final AppCoordinator coordinator;
  final Uri? redirect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                authService.isAuthenticated = true;
                final route = coordinator.parseRouteFromUri(
                  redirect ?? Uri(path: '/'),
                );
                coordinator.replace(route);
              },
              child: Text('Login and redirect back to: $redirect'),
            ),
            TextButton(
              onPressed: () {
                coordinator.push(Register());
              },
              child: Text('Go to register'),
            ),
          ],
        ),
      ),
    );
  }
}
