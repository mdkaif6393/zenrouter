## 0.2.0

### New Features

- **Route Groups `(name)`**: Wrap routes in a layout without adding the folder name to the URL path
  - Folders named with parentheses like `(auth)` create route groups
  - Routes inside `(auth)/login.dart` generate URL `/login` (not `/(auth)/login`)
  - Routes are still wrapped by the `_layout.dart` in that folder
  - Useful for grouping auth flows, marketing pages, or applying shared styling

## 0.1.0

- Initial release of zenrouter_file_generator with file-based routing support for Flutter.