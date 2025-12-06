# ZenRouter File Annotation

Shared annotations and structure for [zenrouter](https://pub.dev/packages/zenrouter) file-based routing.

This package contains the annotations (`@ZenRoute`, `@ZenLayout`, `@ZenCoordinator`) and helper classes used by the `zenrouter_file_generator` to generate type-safe routes.

## Installation

This package is usually added automatically when using `zenrouter_file_generator`.

```yaml
dependencies:
  zenrouter_file_annotation: ^0.2.1

dev_dependencies:
  zenrouter_file_generator: ^0.2.1
```

## Usage

Use these annotations to define your routes and layouts:

```dart
import 'package:zenrouter_file_annotation/zenrouter_file_annotation.dart';

@ZenRoute()
class MyRoute extends _$MyRoute { ... }

@ZenLayout(type: LayoutType.stack)
class MyLayout extends _$MyLayout { ... }
```

See [zenrouter_file_generator](https://pub.dev/packages/zenrouter_file_generator) for complete documentation and usage examples.
