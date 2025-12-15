# Migration Guide

This guide outlines the changes and steps required to migrate to the latest version of `zenrouter`.

## Path Constructors

The constructors for `NavigationPath` and `IndexedStackPath` have been updated to provide better clarity and type safety, especially when binding to a `Coordinator`.

### Changes

- **Deprecated**: The default unnamed constructors `NavigationPath(...)` and `IndexedStackPath(...)`.
- **New**: `create` factory constructor for creating paths with optional arguments.
- **New**: `createWith` factory constructor for creating paths that are explicitly bound to a `Coordinator`.

### Migration

Replace direct constructor calls with `create` or `createWith`:

**Before:**
```dart
final path = NavigationPath(
  'root',
  [],
  coordinator,
);
```

**After (Standard):**
```dart
final path = NavigationPath.create(
  label: 'root',
  stack: [],
  coordinator: coordinator,
);
```

**After (With explicit Coordinator):**
```dart
late final path = NavigationPath.createWith(
  coordinator: this,
  label: 'root',
  stack: [],
);
```

Same applies to `IndexedStackPath`.

## RouteGuard API

The `RouteGuard` mixin has been enhanced to support coordinator validation during pop operations.

### Changes

- **New**: `popGuardWith(Coordinator coordinator)` method.
  - This method is called by the framework when a pop is attempted.
  - It asserts that the route's path is associated with the correct coordinator.
  - It internally calls `popGuard()`.

- **Existing**: `popGuard()` remains the place to implement your custom guard logic.

### Migration

If you are manually calling `popGuard` in your custom logic or tests, consider using `popGuardWith` if you have access to the coordinator to benefit from the additional checks.

No changes are needed for existing `popGuard` implementations unless you are overriding the default behavior significantly.

## RouteRedirect API

The `RouteRedirect` mixin has been updated similarly to `RouteGuard`.

### Changes

- **New**: `redirectWith(Coordinator coordinator)` method.
  - Called by the framework during route resolution.
  - Helps ensuring the path belongs to the correct coordinator context.
  - Internally calls `redirect()`.

- **Existing**: `redirect()` remains the place to implement your redirect logic.

## Internal Properties (`internalProps`)

A new property `internalProps` has been introduced to the `Equatable` base class (and consequently `RouteTarget`) to handling deep comparison and hashing of internal state.

### Changes

- **`internalProps`**: A list of properties used for calculating `hashCode` and ensuring object identity, separate from the public `props`.
- `RouteTarget` now includes `runtimeType`, `_path`, and the internal result completer in `internalProps`.

### Impact

This ensures that `RouteTarget` instances are correctly distinguished even if they have identical configuration `props`, especially when they belong to different paths or have different lifecycle states. This improves the reliability of deep comparisons and sets containing routes.
