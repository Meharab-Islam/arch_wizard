A simple command-line application.
# Arch Wizard 🧙✨

A powerful CLI tool to scaffold Flutter clean architecture features, boosting productivity and ensuring consistency across your projects.

### **Overview**

`arch_wizard` automates the creation of boilerplate code for features, including domain, data, and presentation layers. It supports BLoC, Riverpod, GetX, and Provider, and can automatically register dependencies with GetIt.



### **Installation**

Activate `arch_wizard` to use it globally from any terminal.

```bash
dart pub global activate arch_wizard
```
*(This command will work once the package is published to pub.dev.)*

### **Usage**

1.  **Prepare your project:** In your Flutter project's `get_it` setup file (e.g., `lib/injection_container.dart`), add the marker comment where you want new dependencies to be inserted.
    ```dart
    Future<void> init() async {
      // ... other registrations
    
      // [DI_GENERATE_HERE]
    }
    ```
2.  **Run the command:** Navigate to the root of your Flutter project and run the `create_feature` command.

    ```bash
    arch_wizard create_feature --name user_profile --state riverpod
    ```
This will generate the entire feature structure and attempt to update `injection_container.dart` automatically.

### **Commands**

#### `create_feature`
Creates all the necessary files for a new feature.

**Options:**

- `--name` (or `-n`): **(required)** The name of the feature in snake_case (e.g., `user_profile`).
- `--state` (or `-s`): The state management solution.
  - `bloc` (default)
  - `riverpod`
  - `getx`
  - `provider`