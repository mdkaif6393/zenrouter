import 'package:flutter/material.dart';
import 'package:zenrouter/zenrouter.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

sealed class BookRoute with RouteTarget {
  Widget build(BuildContext context);
}

class BookList extends BookRoute {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book list')),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text("The list page"),
            TextButton(
              onPressed: () => bookPath.push(BookDetail(title: 'New book')),
              child: Text('Add new book'),
            ),
            TextButton(
              onPressed: () => bookPath.push(BookSheet(title: 'New sheet')),
              child: Text('Add new sheet'),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetail extends BookRoute with RouteGuard {
  BookDetail({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text("The detailed page"),
            TextButton(
              onPressed: () => bookPath.clear(),
              child: Text('Back to list'),
            ),
            TextButton(
              onPressed: () async {
                final result = await bookPath.push(
                  BookDetail(title: 'New book ${context.hashCode}'),
                );
                print('Result from book path: $result');
              },
              child: Text('Add new book'),
            ),
            TextButton(
              onPressed: () => bookPath.pop('Popped from $title'),
              child: Text('Pop'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<bool> popGuard() async {
    if (title == 'New book') {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    }
    return true;
  }
}

class BookSheet extends BookRoute {
  BookSheet({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Text("The sheet page"),
            TextButton(onPressed: () => bookPath.pop(), child: Text('Pop')),
          ],
        ),
      ),
    );
  }
}

final bookPath = NavigationPath<BookRoute>()..push(BookList());

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationStack<BookRoute>(
      path: bookPath,
      resolver: (route) => switch (route) {
        BookList() => .material(route.build(context)),
        BookDetail() => .material(route.build(context), guard: route),
        BookSheet() => .sheet(route.build(context)),
      },
    );
  }
}

class BookSheetView extends StatelessWidget {
  const BookSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
