---

# Flutcn UI CLI

![Dart](https://img.shields.io/badge/Dart-3.6.2-blue.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg) ![GitHub](https://img.shields.io/github/stars/OmarElhassaniAlaoui/flutcn_ui)

**Flutcn UI** is a command-line interface (CLI) tool designed to streamline Flutter development by automating the setup of UI themes and the addition of pre-defined widgets. It integrates with your Flutter project to provide a consistent design system, leveraging customizable themes and a widget registry.

## Features

- **Project Initialization**: Set up your Flutter project with a theme directory, widget directory, and configuration file.
- **Widget Addition**: Fetch and add pre-built widgets from a registry to your project.
- **Customizable Themes**: Choose from base color palettes (e.g., Zinc, Slate, Gray) and styles (e.g., New York).
- **User-Friendly**: Interactive prompts and spinners for a smooth CLI experience.

## Prerequisites

- **Dart SDK**: Version 3.6.2 or higher.
- **Flutter**: Installed and configured (required for Flutter projects where the CLI is used).

## Installation

### From Source

Clone the repository and install locally:

```bash
git clone https://github.com/OmarElhassaniAlaoui/flutcn_ui.git
cd flutcn_ui
dart pub get
dart pub global activate --source path .
```

### From Pub

install globally with:

```bash
dart pub global activate flutcn_ui
```

Ensure the Dart `pub` cache bin directory (e.g., `~/.pub-cache/bin`) is in your system's PATH.

## Usage

Run `flutcn_ui` commands from the root of your Flutter project (where `pubspec.yaml` exists).

### Initialize a Project

Set up Flutcn UI in your project:

```bash
flutcn_ui init [--default]
```

- **Without `--default`**: Prompts for:
  - **Theme Path**: Where theme files are stored (default: `lib/themes`).
  - **Widgets Path**: Where widget files are stored (default: `lib/widgets`).
  - **Style**: UI style (options: `new-york`, `default`).
  - **Base Color**: Color palette (options: `zinc`, `slate`, `gray`, etc.).
- **With `--default`**: Uses defaults:
  - Theme Path: `lib/themes`
  - Widgets Path: `lib/widgets`
  - Style: `new-york`
  - Base Color: `zinc`

**Output**:
- Creates `lib/themes/app_pallete.dart` and `lib/themes/app_theme.dart` with the selected palette and theme.
- Creates a `flutcn.config.json` file in the project root.

**Example**:
```bash
flutcn_ui init
# Follow prompts to configure
```

```bash
flutcn_ui init --default
# Uses default settings
```

### Add a Widget

Add a widget from the registry:

```bash
flutcn_ui add <widget-name>
```

- **Requirements**: `flutcn.config.json` must exist (run `init` first).
- **Behavior**: Fetches the widget template (e.g., `button`) based on the style in `flutcn.config.json` and saves it to the widgets path (e.g., `lib/widgets/button.dart`).

**Example**:
```bash
flutcn_ui add button
# Adds lib/widgets/button.dart
```

## Configuration

The `flutcn.config.json` file is generated during `init` and contains:

```json
{
  "widgetsPath": "lib/widgets",
  "themePath": "lib/themes",
  "style": "new-york",
  "baseColor": "zinc"
}
```

Edit this file manually to adjust paths or style, though re-running `init` is recommended for consistency.

## Dependencies

The generated theme (`app_theme.dart`) uses the `google_fonts` package. Add it to your Flutter project’s `pubspec.yaml`:

```yaml
dependencies:
  google_fonts: ^6.0.0
```

Run `flutter pub get` after adding this dependency.

## Troubleshooting

- **"Flutcn UI is not initialized"**:
  - Run `flutcn_ui init` to create `flutcn.config.json`.
- **"Please specify a widget name"**:
  - Provide a widget name, e.g., `flutcn_ui add button`.
- **Theme files not generated**:
  - Ensure you’re in a Flutter project root (with `pubspec.yaml`).
  - Verify the CLI is installed correctly (`dart pub global activate --source path .` from the package root).
- **Network errors**:
  - The `add` command requires a running API at `http://localhost:3000/registry`. Set up a local server or update the API URL in `bin/injection_container.dart`.

## Development

### Project Structure

- `bin/`: CLI entry point and commands (`flutcn_ui.dart`, `init.dart`, `add.dart`).
- `lib/src/core/`: Utilities and constants (e.g., `file_paths.dart`, `spinners.dart`).
- `lib/src/data/`: Data layer (models, services, repositories).
- `lib/src/domain/`: Domain layer (entities, use cases).

### Running Locally

From the package root:

```bash
dart run bin/flutcn_ui.dart init --default
```

### Building and Testing

1. Install dependencies:
   ```bash
   dart pub get
   ```
2. Run tests (if implemented):
   ```bash
   dart test
   ```
   
## Contributing

We welcome contributions! To contribute:

1. Fork the repository: [github.com/OmarElhassaniAlaoui/flutcn_ui](https://github.com/OmarElhassaniAlaoui/flutcn_ui).
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m "Add feature"`).
4. Push to your fork (`git push origin feature-name`).
5. Open a pull request with a detailed description.

For major changes, open an issue first to discuss with maintainers.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with [Dart](https://dart.dev/) and inspired by tools like [Shadcn UI](https://ui.shadcn.com/).
- Thanks to the Flutter community for continuous inspiration.

## Maintainers ✨

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/OmarElhassaniAlaoui"> 
        <img src="https://avatars.githubusercontent.com/u/102819564?v=4" width="100px;" alt=""/>
        <br />
        <sub><b>Omar Elhassani Alaoui</b></sub>
      </a>
    </td>
  </tr>
</table>

---
