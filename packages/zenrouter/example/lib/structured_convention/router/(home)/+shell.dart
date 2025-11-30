part of '../../coordinator.dart';

sealed class HomeShell extends AppRoute
    with RouteShellStateful<HomeShell>, RouteRedirect {
  @override
  NavigationPath getPath(AppCoordinator coordinator) => coordinator.home;

  @override
  HomeShell get shellHost => _$HomeShellHost.instance;

  @override
  FutureOr<HomeShell?> redirect() async {
    // GO DIRECTLY TO LOGIN IF NOT AUTHENTICATED
    if (!authService.isAuthenticated) {
      coordinator.replace(Login());
      return null;
    }
    return this;
  }
}

class _$HomeShellHost extends HomeShell
    with RouteShellStatefulHost<HomeShell>, RouteBuilder {
  static final instance = _$HomeShellHost();

  @override
  NavigationPath getHostPath(AppCoordinator coordinator) => coordinator.root;

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: coordinator.home.activePathIndex,
              children: coordinator.home.stack
                  .map((route) => resolver(coordinator, context, route))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: coordinator.home,
        builder: (context, _) {
          final currentIndex = coordinator.home.activePathIndex;
          return NavigationBar(
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
              NavigationDestination(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
            selectedIndex: currentIndex,
            onDestinationSelected: (value) => switch (value) {
              0 => coordinator.pushOrMoveToTop(Feed()),
              1 => coordinator.pushOrMoveToTop(Notification()),
              2 => coordinator.pushOrMoveToTop(Search()),
              3 => coordinator.pushOrMoveToTop(Settings()),
              _ => null,
            },
          );
        },
      ),
    );
  }
}
