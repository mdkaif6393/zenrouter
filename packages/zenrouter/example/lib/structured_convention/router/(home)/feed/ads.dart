part of '../../../coordinator.dart';

class FeedAds extends AppRoute with RouteBuilder, RouteDeepLink {
  @override
  Uri? toUri() => Uri.parse('/feeds/ads');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) {
    return AlertDialog(
      title: const Text('Ads'),
      content: const Text('This is an ad'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  RouteDestination<T> destination<T extends RouteUnique>(
    AppCoordinator coordinator,
  ) {
    final context = coordinator.navigator.context;
    return RouteDestination.dialog(build(coordinator, context));
  }

  @override
  FutureOr<void> deeplinkHandler(AppCoordinator coordinator, Uri uri) {
    /// Make sure the feed is on screen
    coordinator.pushOrMoveToTop(Feed());

    /// Show the ads
    coordinator.push(this);
  }
}
