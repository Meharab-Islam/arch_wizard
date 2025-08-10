
-----

# Arch Wizard 🧙‍♂️✨

[](https://pub.dev/packages/arch_wizard)
[](https://opensource.org/licenses/MIT)
[](https://pub.dev/packages/very_good_analysis)

-----

## Effortless Flutter Feature Scaffolding with Clean Architecture

Stop writing boilerplate and start building features. **Arch Wizard** is a powerful, flexible command-line tool designed to **automate the creation of entire feature modules** for Flutter apps, all perfectly structured according to Clean Architecture principles. Save time, reduce repetitive code, and maintain consistency across your projects and teams.

-----

## ✨ Key Features

  - **Automated Scaffolding**: Generate a complete feature with domain, data, and presentation layers using a single command.
  - **Clean Architecture Enforcement**: Keep your code modular, testable, and maintainable.
  - **Supports Multiple State Management Solutions**: `BLoC`, `Riverpod`, `GetX`, and `Provider`.
  - **Automatic Dependency Injection Registration**: Seamlessly updates your `get_it` service locator setup.
  - **Production-Ready Templates**: Includes robust error handling and architecture best practices.
  - **Automatic Global Failure Classes**: When creating a feature, Arch Wizard **automatically creates the global `Failure` classes and `FailureMapper`** files (if they don't exist) in your project’s `lib/core/error/` directory.

-----

## 🚀 Installation
Add `arch_wizard` to the flutter project:

```bash
flutter pub add arch_wizard
```
Install Arch Wizard globally via Dart's pub tool to use it anywhere:

```bash
dart pub global activate arch_wizard
```

Ensure your system's PATH includes pub global executables so the `arch_wizard` command is recognized.

-----

## 🛠 Usage

### Step 1: Run the Feature Creation Command

From the root of your Flutter project, run the main command:

```bash
arch_wizard create_feature --name <feature_name> --state <state_management>
```

  - Replace `<feature_name>` with your desired feature name (e.g., `login`).
  - Choose your preferred state management from `bloc`, `riverpod`, `getx`, or `provider`.

### Step 2: Example Commands

```bash
# Generate a Login feature using BLoC
arch_wizard create_feature --name login --state bloc

# Generate a Product feature using Riverpod
arch_wizard create_feature --name product --state riverpod

# Generate a Profile feature using GetX
arch_wizard create_feature --name profile --state getx

# Generate a Cart feature using Provider
arch_wizard create_feature --name cart --state provider
```

-----

## 📁 Generated File Structure

Arch Wizard generates a complete and logically separated module for your feature. Here’s a look at the architecture.

### General Structure

All generated features follow this core layout, ensuring consistency and separation of concerns.

```text
<your_project_name>/
└── lib/
    ├── core/
    │   └── error/
    │       ├── failure.dart              # (Auto-generated) Base Failure classes.
    │       └── failure_mapper.dart       # (Auto-generated) Maps exceptions to Failures.
    │
    ├── features/
    │   └── <feature_name>/
    │       ├── data/
    │       │   ├── datasources/
    │       │   │   └── <feature_name>_remote_datasource.dart
    │       │   ├── models/
    │       │   │   └── <feature_name>_model.dart
    │       │   └── repositories/
    │       │       └── <feature_name>_repository_impl.dart
    │       ├── domain/
    │       │   ├── entities/
    │       │   │   └── <feature_name>_entity.dart
    │       │   ├── repositories/
    │       │   │   └── <feature_name>_repository.dart
    │       │   └── usecases/
    │       │       └── <feature_name>_usecase.dart
    │       └── presentation/
    │           # This layer's content changes based on the chosen state management.
    │           # See examples below.
    │
    └── injection_container.dart              # (MODIFIED) Automatically updated with new dependencies.
```

### State Management Variations

The `presentation` layer is tailored to your chosen state management solution. Here are the specific structures generated inside `lib/features/<feature_name>/presentation/`.

#### 🧱 BLoC (`--state bloc`)

```text
presentation/
├── bloc/
│   ├── <feature_name>_bloc.dart
│   ├── <feature_name>_event.dart
│   └── <feature_name>_state.dart
├── pages/
│   └── <feature_name>_page.dart
└── widgets/
    └── <feature_name>_widget.dart
```

#### 🌊 Riverpod (`--state riverpod`)

```text
presentation/
├── notifiers/
│   └── <feature_name>_state_notifier.dart
├── pages/
│   └── <feature_name>_page.dart
├── providers/
│   └── <feature_name>_providers.dart
└── widgets/
    └── <feature_name>_widget.dart
```

#### 🚀 GetX (`--state getx`)

```text
presentation/
├── bindings/
│   └── <feature_name>_binding.dart
├── controllers/
│   └── <feature_name>_controller.dart
├── pages/
│   └── <feature_name>_page.dart
└── widgets/
    └── <feature_name>_widget.dart
```

#### ChangeNotifier For Provider (`--state provider`)

```text
presentation/
├── pages/
│   └── <feature_name>_page.dart
├── providers/
│   └── <feature_name>_provider.dart
└── widgets/
    └── <feature_name>_widget.dart
```

-----

## ⚙️ Command Options

| Option    | Alias | Description                   | Allowed Values                         | Default |
| --------- | ----- | ----------------------------- | -------------------------------------- | ------- |
| `--name`  | `-n`  | Name of the feature to create | Any valid string (e.g., `login`)       | —       |
| `--state` | `-s`  | State management approach     | `bloc`, `riverpod`, `getx`, `provider` | `bloc`  |

-----

## 💡 Tips for Customization

  - Generated templates include clear comments and `TODO`s to guide you in customizing API calls, UI, and business logic.
  - Supports multi-layer clean architecture, so you can replace or extend any layer independently.
  - Easily integrate with your existing codebase by following the generated file and folder structure.

-----

## 🤝 Contributing

Contributions are welcome\! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

-----

## 📜 License

Arch Wizard is open-source software licensed under the **MIT License**. See the `LICENSE` file for details.

-----

### Happy coding\! 🎉

Build clean, scalable Flutter apps faster with Arch Wizard.