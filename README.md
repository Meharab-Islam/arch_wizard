# Arch Wizard 🧙‍♂️✨

[![Pub Version](https://img.shields.io/pub/v/arch_wizard)](https://pub.dev/packages/arch_wizard)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Style: Very Good Analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

---

## Effortless Flutter Feature Scaffolding with Clean Architecture

Arch Wizard is a powerful, flexible **command-line tool** designed to **automate the creation of entire feature modules** for Flutter apps — structured according to clean architecture principles.
Save time, reduce boilerplate, and maintain consistency across your projects and teams.

---

## ✨ Key Features

* **Full Feature Scaffolding:** Generate complete feature folders with domain, data, and presentation layers in a single command.
* **Clean Architecture Enforced:** Clear separation between layers, making your app scalable and maintainable.
* **Multi-State Management Support:** Choose from `BLoC`, `Riverpod`, `GetX`, or `Provider` for your presentation layer.
* **Automatic Dependency Injection (DI):** Your new feature’s dependencies and imports are seamlessly registered in your `get_it` service locator file.
* **Production-Ready Templates:** Includes robust error handling, clear comments, and easy customization.

---

## 🚀 Installation

Install Arch Wizard globally via Dart's pub tool to use it anywhere:

```bash
dart pub global activate arch_wizard
```

Ensure your PATH includes pub global executables, so the command `arch_wizard` is recognized.

---

## 🛠 Usage

### Step 1: Run the Feature Creation Command

From the root of your Flutter project, run:

```bash
arch_wizard create_feature --name <feature_name> --state <state_management>
```

Replace `<feature_name>` with your desired feature name (e.g., `login`).
Choose your preferred state management from `bloc`, `riverpod`, `getx`, or `provider`.

---

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

---

### Step 3: What Happens?

* Creates the full directory structure inside:
  `lib/features/<feature_name>/`
* Generates domain, data, and presentation files with appropriate templates.
* Automatically updates your DI file (e.g., `lib/injection_container.dart`) with new imports and registrations.

---

## ⚙️ Command Options

| Option    | Alias | Description                   | Allowed Values                         | Default |
| --------- | ----- | ----------------------------- | -------------------------------------- | ------- |
| `--name`  | `-n`  | Name of the feature to create | Any valid string (e.g., `login`)       | —       |
| `--state` | `-s`  | State management approach     | `bloc`, `riverpod`, `getx`, `provider` | `bloc`  |

---

## 💡 Tips for Customization

* Generated templates include clear comments and `TODO`s to guide you customizing API calls, UI, and business logic.
* Supports multi-layer clean architecture, so you can replace or extend any layer independently.
* Easily integrate with your existing codebase by following the generated file and folder structure.

---

## 📜 License

Arch Wizard is open source software licensed under the **MIT License**. See the LICENSE file for details.

---

### Happy coding! 🎉

Build clean, scalable Flutter apps faster with Arch Wizard.

---

