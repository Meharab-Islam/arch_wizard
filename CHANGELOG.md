## 1.0.3

- Added automatic generation of **global Failure classes** (`failures.dart` and `failure_mapper.dart`) in `lib/core/error/` when creating a new feature, ensuring consistent, reusable error handling across the app.
- Improved repository implementation template to use `FailureMapper` for robust and professional exception-to-failure conversion.
- Updated presentation layer templates to include **clear comments and usage guidance** instead of direct API call code, making them flexible for various use cases.
- Enhanced DI registration code with better error logging and file creation handling.
- Refined CLI error handling and log writing for better developer experience during feature generation.
- Improved template structure and comments to increase code clarity and maintainability.

## 1.0.2

- Updated the README file with clearer instructions and feature descriptions.

## 1.0.1

- Fixed an issue in the Riverpod template to correctly handle error states and code generation.
- Added automatic DI file creation if it doesn't exist.
- Updated templates with robust error handling.

## 1.0.0

- Initial stable release of Arch Wizard.
- Feature scaffolding for Domain, Data, and Presentation layers.
- Support for BLoC, Riverpod, GetX, and Provider state management.
- Automatic dependency injection and import registration for `get_it`.
- Production-ready templates with error handling patterns.
