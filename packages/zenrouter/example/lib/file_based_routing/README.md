## File-based routing example with `zenrouter_file_generator`

This example shows how to use **`zenrouter_file_generator`** to get Next.js / Nuxt.js–style **file-based routing** on top of `zenrouter`.

### What this example demonstrates

- **File = route**: each Dart file in `lib/routes/` becomes a route.
- **Dynamic segments**: files like `[id].dart` map to `/path/:id`.
- **Layouts**: `_layout.dart` wraps child routes with a shared layout.
- **Type-safe navigation**: generated methods like `coordinator.goToAbout()` or `coordinator.pushProfileId('123')`.

### How to run the example

From the repository root:

```bash
cd packages/zenrouter_file_generator/example
flutter pub get
dart run build_runner build
flutter run
```

This will:

1. Use `zenrouter_file_generator` to scan `lib/routes/`.
2. Generate route base classes (e.g. `about.g.dart`) and `routes.zen.dart`.
3. Start the Flutter app wired up to the generated `AppCoordinator`.

### How it’s wired together

- `lib/routes/` contains your route files (`index.dart`, `about.dart`, `profile/[id].dart`, `tabs/_layout.dart`, etc.).
- Each route class is annotated with `@ZenRoute()` (and layouts with `@ZenLayout()`).
- `dart run build_runner build` generates:
  - `*.g.dart` files with base route/layout classes.
  - `routes.zen.dart` with:
    - `AppRoute` / `AppCoordinator`
    - URL parsing (`parseRouteFromUri`)
    - type-safe navigation extensions.
- `main.dart` uses `MaterialApp.router` with the generated `AppCoordinator`.

### What to look at

When exploring the example, check:

- `lib/routes/` – how file names map to URLs.
- Generated `routes.zen.dart` – coordinator and navigation helpers.
- Any `@ZenRoute`, `@ZenLayout`, and optional `_coordinator.dart` configuration.

This small example is the best place to see how `zenrouter_file_generator` fits into a real app before you integrate it into your own project.


