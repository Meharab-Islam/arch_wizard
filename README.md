# Arch Wizard 🧙✨

[![Pub Version](https://img.shields.io/pub/v/arch_wizard)](https://pub.dev/packages/arch_wizard)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)

A powerful and flexible command-line tool to scaffold complete features for your Flutter projects using a clean architecture pattern. Drastically reduce boilerplate and enforce consistency across your team.



---

### **Features**

-   **Automated Scaffolding**: Generate the entire directory structure for a new feature with a single command.
-   **Clean Architecture**: Enforces a solid, scalable architecture with a clear separation of layers (Domain, Data, Presentation).
-   **State Management Support**: Out-of-the-box templates for BLoC, Riverpod, GetX, and Provider.
-   **Automatic DI Registration**: Automatically injects your new dependencies and imports into a `get_it` service locator file.
-   **Production-Ready Templates**: Generates code with robust error-handling patterns.

---

### **Installation**

Activate `arch_wizard` from your terminal to make it available as a system-wide command.

```bash
dart pub global activate arch_wizard
```

---

### **Usage**


#### **1. Run the Command**

Navigate to the root directory of your Flutter project and run the `create_feature` command.

```bash
arch_wizard create_feature --name <your_feature_name> --state <state_management>
```

**Examples:**

```bash
# Create a 'login' feature using BLoC
arch_wizard create_feature --name login --state bloc

# Create a 'cart' feature using Riverpod
arch_wizard create_feature --name cart --state riverpod
```

The tool will create all the necessary files in `lib/features/<your_feature_name>/` and update your dependency injection file automatically.

---

### **Command Options**

| Option      | Abbreviation | Description                      | Allowed Values                       | Default |
|-------------|--------------|----------------------------------|--------------------------------------|---------|
| `--name`    | `-n`         | The name of the feature.         | (string)                             |         |
| `--state`   | `-s`         | The state management solution.   | `bloc`, `riverpod`, `getx`, `provider` | `bloc`  |

---

### **Bugs or Requests**

If you encounter any problems, feel free to [open an issue](https://github.com/Meharab-Islam/arch_wizard/issues).

---

### **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.