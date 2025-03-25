# Flutcn UI CLI

![Dart](https://img.shields.io/badge/Dart-3.6.2-blue.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg) ![GitHub](https://img.shields.io/github/stars/OmarElhassaniAlaoui/flutcn_ui)

**Flutcn UI** is a command-line interface (CLI) tool designed to streamline Flutter development by automating the setup of UI themes and the addition of pre-defined widgets. It integrates with your Flutter project to provide a consistent design system, leveraging customizable themes and a widget registry.

## Features

- **Project Initialization**: Set up your Flutter project with a theme directory, widget directory, and configuration file.
- **Smart Widget Management**:
  - Add individual widgets or select multiple from an interactive list
  - Overwrite confirmation for existing files
  - Batch operations for multiple components
- **Customizable Themes**: Choose from base color palettes (e.g., Zinc, Slate, Gray) and styles (e.g., New York).
- **Interactive Experience**: 
  - Visual spinners for long operations
  - Conflict resolution prompts
  - Color-coded output messages

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
Install globally with:

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
  - **Theme Path**: Where theme files are stored (default: `lib/themes`)
  - **Widgets Path**: Where widget files are stored (default: `lib/widgets`)
  - **Style**: UI style (options: `new-york`, `default`)
  - **Base Color**: Color palette (options: `zinc`, `slate`, `gray`, etc.)
- **With `--default`**: Uses defaults:
  - Theme Path: `lib/themes`
  - Widgets Path: `lib/widgets`
  - Style: `new-york`
  - Base Color: `zinc`

**Output**:
- Creates theme files with selected palette and theme
- Generates configuration file `flutcn.config.json`

**Examples**:
```bash
# Interactive setup
flutcn_ui init

# Quick start with defaults
flutcn_ui init --default
```

### Add Widgets

Add components from the registry:

**Single Widget**:
```bash
flutcn_ui add <widget-name>
```

**Multiple Widgets (Interactive)**:
```bash
flutcn_ui add
# Then select from the widget list using spacebar
```

**Features**:
- Automatically detects existing files
- Prompts to overwrite, skip, or cancel
- Preserves your customizations when skipping

**Examples**:
```bash
# Add a single widget
flutcn_ui add button

# Multi-select interface
flutcn_ui add
? Select widgets: (Use space to choose)
✔ [•] button
  [ ] card
  [•] avatar
```

### List Available Widgets

Discover components in the registry:

```bash
flutcn_ui list
```

**Output**:
- Interactive multi-select interface
- Batch download capability
- Shows download progress and results

## Configuration

The `flutcn.config.json` file controls project settings:

```json
{
  "widgetsPath": "lib/widgets",
  "themePath": "lib/themes",
  "style": "new-york",
  "baseColor": "zinc"
}
```

**Note**: Manual edits are possible, but re-running `init` is recommended for major changes.

## Dependencies

The generated theme requires the `google_fonts` package. Add to `pubspec.yaml`:

```yaml
dependencies:
  google_fonts: ^6.0.0
```

Run `flutter pub get` after adding this dependency.

## Troubleshooting

- **Existing File Conflicts**:
  - Use overwrite/skip prompts during add operations
  - Delete existing files manually if needed
- **Component Not Found**:
  - Verify registry connectivity
  - Check available widgets with `flutcn_ui list`
- **Configuration Issues**:
  - Re-initialize with `flutcn_ui init`
  - Validate JSON syntax in `flutcn.config.json`

## Development

### Project Structure

- `bin/`: CLI entry points and commands
- `lib/src/core/`: Utilities and constants
- `lib/src/data/`: Data layer services
- `lib/src/domain/`: Business logic and entities

### Recent Improvements

- ✔ Interactive multi-widget selection
- ✔ File conflict resolution system
- ✔ Batch operation progress tracking
- ✔ Enhanced error handling

## Roadmap ✨

- [ ] Delete unused widgets command
- [ ] Version diff checking
- [ ] Component update system
- [ ] Template override support

## Contributing

We welcome contributions! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit changes (`git commit -m "Add feature"`)
4. Push to branch (`git push origin feature-name`)
5. Open a Pull Request

For major changes, please open an issue first to discuss proposed changes.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Inspired by [Shadcn UI](https://ui.shadcn.com/)'s design philosophy
- Built with Dart's powerful CLI capabilities
- Supported by the Flutter community's innovations

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
