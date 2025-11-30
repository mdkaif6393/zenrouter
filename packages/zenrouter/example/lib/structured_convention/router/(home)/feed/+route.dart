part of '../../../coordinator.dart';

class Feed extends HomeShell with RouteBuilder {
  @override
  Uri? toUri() => Uri.parse('/feeds');

  @override
  Widget build(AppCoordinator coordinator, BuildContext context) => FeedPage();
}

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  final controller = PageController();
  late final tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Page')),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            onTap: (value) {
              tabController.animateTo(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              controller.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tabs: [
              Tab(text: 'For you'),
              Tab(text: 'Following'),
            ],
          ),
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('For you'),
                      Counter(),
                      TextButton(
                        onPressed: () => coordinator.push(FeedAds()),
                        child: Text('Show ads'),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text('Following'), Counter()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
