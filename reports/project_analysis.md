# Flutcn UI Project Analysis

> **Version analyzed:** 1.1.2 | **Dart files:** 43 | **LOC (lib/src/):** ~1,090 | **Branch:** dev

## 1. Project Overview

**flutcn_ui** is a command-line tool for Flutter, inspired by `shadcn/ui`. It fetches pre-built, customizable UI components from a remote registry (`https://flutcnui.netlify.app`) and integrates them into Flutter projects with theme support.

**Core capabilities:**
- `init` — Set up project with `flutcn.config.json`, generate theme files
- `add` — Download and install widgets (single or batch)
- `list` — Browse and install available widgets interactively

## 2. Architecture

The project follows **Clean Architecture** with three layers:

```
lib/src/
├── core/          # Shared utilities, constants, error types, base classes
├── data/          # API client, file I/O, models, repository implementations
└── domain/        # Entities, repository interfaces, use cases
```

### Data Flow

```
CLI Command (bin/commands/)
    ↓
Use Case (domain/usecases/)
    ↓
Repository Interface (domain/repository/)
    ↓
Repository Implementation (data/repository/)
    ↓
Data Source Interface (data/interfaces/)
    ↓
Data Source Implementation (data/services/)
    ↓
API Service (core/services/ → data/services/)
```

### Key Patterns

| Pattern | Implementation |
|---------|---------------|
| **Dependency Injection** | GetIt service locator (`sl<Type>()`) registered in `bin/injection_container.dart` |
| **Functional Error Handling** | `Either<Failure, T>` from `dartz` — Left = error, Right = success |
| **Entity-Model Separation** | Pure entities in domain, models extend entities with JSON serialization in data |
| **Abstract Interfaces** | `ApiService`, `CommandInterface`, `CommandRepository` — all coded to interfaces |

### Layer Dependencies

```
Domain Layer → (no dependencies)
Data Layer   → Domain Layer, Core
CLI Commands → Domain Layer, Data Layer, Core
```

No circular dependencies detected.

## 3. Dependencies

**Dart SDK:** `^3.6.2`

### Runtime

| Package | Version | Purpose |
|---------|---------|---------|
| `args` | `^2.6.0` | CLI argument parsing |
| `cli_spin` | `^1.0.1` | Spinner animations for async operations |
| `dartz` | `^0.10.1` | `Either<L, R>` functional error handling |
| `equatable` | `^2.0.7` | Value equality for entities |
| `get_it` | `^8.0.3` | Service locator / DI container |
| `http` | `^1.3.0` | HTTP client for registry API |
| `io` | `^1.0.5` | Console I/O utilities |
| `path` | `^1.8.0` | Cross-platform path manipulation |
| `prompts` | `^2.0.0` | Interactive CLI prompts |

### Dev

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | `^2.4.6` | Code generation (prepared, not actively used) |
| `lints` | `^5.0.0` | `package:lints/recommended.yaml` lint rules |
| `test` | `^1.24.0` | Test framework (present but unused) |

## 4. CLI Commands

### `init`
- Checks if project is already initialized (`flutcn.config.json` exists)
- Supports `--default` flag for quick setup (skips prompts)
- Interactive prompts: theme path, widgets path, style, base color, Google Fonts
- Creates directories, fetches theme files from registry, writes config
- Optionally adds `google_fonts` to `pubspec.yaml`

**Default config:**
```json
{
  "widgetsPath": "lib/widgets",
  "themePath": "lib/themes",
  "style": "new-york",
  "baseColor": "Zinc"
}
```

### `add`
- **Single mode:** `flutcn_ui add button` — downloads and writes widget directly
- **Multi-select mode:** `flutcn_ui add` — shows interactive checkbox UI
- Builds widget URL: `{registry}/widgets/{style}/{widgetName}`
- Writes `.dart` files to configured widgets directory
- Tracks successes and failures in batch mode

### `list`
- Fetches all available widgets from registry
- Shows interactive multi-select interface
- Checks for existing files before writing (overwrite/skip/cancel)
- Prints color-coded summary: green (success), yellow (skipped), red (failed)

## 5. API Integration

**Production base URL:** `https://flutcnui.netlify.app/registry/`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/widgets` | GET | List all available widgets |
| `/widgets/{style}/{name}` | GET | Download individual widget source |
| `/colorScheme/{style}/{baseColor}` | GET | Fetch color palette file |
| `/theme/{style}` | GET | Fetch theme definition file |

- No authentication required (public API)
- Response wrapper: `ApiResponse` (body, statusCode, message)
- Dev URL available (`localhost:3000`) but not used in production builds

## 6. Configuration Management

**File:** `flutcn.config.json` (project root)

```json
{
  "widgetsPath": "lib/widgets",
  "themePath": "lib/themes",
  "style": "new-york",
  "baseColor": "zinc"
}
```

- Created by `init` command
- Required before `add` or `list` commands
- Entity (`InitConfigEntity`) supports JSON serialization
- **No schema validation** — config values are trusted as-is

## 7. Code Quality — Strengths

- **Clean Architecture** — proper layer separation, no layer violations
- **Functional error handling** — `Either<Failure, T>` prevents null-related crashes
- **Comprehensive failure types** — 10 specific failure classes for different error scenarios
- **Cross-platform CLI UX** — platform-aware keyboard handling (Windows vs. Mac/Linux key codes)
- **Visual feedback** — spinners, color-coded output, interactive selection
- **Singleton DI** — lazy registration prevents unnecessary initialization

## 8. Bugs & Issues

### Bug: API Service `get()` missing base URL
**File:** `lib/src/data/services/api_service.dart`, line ~23

The `get()` method parses the endpoint directly without prepending `baseUrl`:
```dart
final uri = Uri.parse(endpoint);  // BUG: should be Uri.parse('$baseUrl$endpoint')
```
All other methods (`post`, `put`, `update`, `delete`) correctly use `'$baseUrl$endpoint'`.

### Bug: Variable name typo
**File:** `lib/src/data/services/command_interface_impl.dart`, line ~72

```dart
Future<void> _createConfigFile(
  String? widgetsPaht,  // Should be: widgetsPath
  ...
)
```

### Issue: Filename typos
| Current Name | Should Be |
|-------------|-----------|
| `qestions.dart` | `questions.dart` |
| `app_pallete.dart` | `app_palette.dart` |
| `checko_box_chooser.dart` | `checkbox_chooser.dart` |

### Issue: Error handling inconsistency
`ListUseCase` throws exceptions instead of returning `Either<Failure, T>`:
```dart
// ListUseCase — breaks the pattern
return result.fold(
  (failure) => throw Exception(failure.message),  // Should propagate Either
  (widgets) => widgets,
);
```
Both `InitUseCase` and `AddUseCase` correctly return `Either`.

## 9. Unused & Commented-Out Code

### Empty use case files (placeholders)
- `lib/src/domain/usecases/add_theme_usecase.dart` — empty
- `lib/src/domain/usecases/search_usecase.dart` — empty
- `lib/src/domain/usecases/update_usecase.dart` — empty

### Legacy constant
- `lib/src/core/constants/app_constants.dart` — contains `baseUrl = 'https://flutcn.com/api/v1'` which is never referenced

### Commented-out state management
State management selection is prepared across multiple files but fully commented out:
- `InitConfigEntity` — `stateManagement` field commented
- `CommandInterfaceImpl` — switch statement for bloc/provider/riverpod commented
- `InitCommand` — state management prompt commented

## 10. Test Coverage

**Current state: Minimal**

- Only file: `example/test_flutcn/test/widget_test.dart` (default Flutter template)
- No unit tests for use cases, repositories, or services
- No integration tests for CLI commands
- `test` package is in dev dependencies but unused

**Recommended test priorities:**
1. Use cases (pure business logic, easy to test)
2. Repository implementations (mock API service)
3. CLI commands (integration tests with mock DI)
4. API service (HTTP response handling)

## 11. Improvement Recommendations

### Priority 1 — Fix Bugs
- [ ] Fix `get()` method in `HttpServiceImpl` to prepend `baseUrl`
- [ ] Fix `widgetsPaht` typo in `command_interface_impl.dart`
- [ ] Rename misspelled files (`qestions.dart`, `app_pallete.dart`, `checko_box_chooser.dart`)
- [ ] Fix `ListUseCase` to return `Either` instead of throwing

### Priority 2 — Code Hygiene
- [ ] Remove empty use case files or implement them
- [ ] Remove unused `AppConstants.baseUrl`
- [ ] Either implement state management feature or remove commented code

### Priority 3 — Reliability
- [ ] Add unit tests for use cases and repositories
- [ ] Add config file schema validation
- [ ] Add offline fallback / graceful error when registry is unreachable

### Priority 4 — Features
- [ ] `remove` command — uninstall widgets
- [ ] `update` command — update installed widgets
- [ ] Widget versioning — track installed versions
- [ ] `--path` option on `add` command — override default widget directory
- [ ] Dependency resolution for widget inter-dependencies

## 12. File Structure

```
flutcn_ui/
├── bin/
│   ├── flutcn_ui.dart                  # CLI entry point
│   ├── injection_container.dart        # GetIt DI setup
│   └── commands/
│       ├── init.dart                   # Init command (131 LOC)
│       ├── add.dart                    # Add command (187 LOC)
│       └── list.dart                   # List command (165 LOC)
├── lib/src/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart      # API URLs (dev + prod)
│   │   │   ├── app_constants.dart      # Legacy unused constant
│   │   │   ├── file_paths.dart         # Default widget/theme paths
│   │   │   └── qestions.dart           # CLI prompt definitions
│   │   ├── errors/
│   │   │   ├── exceptions.dart         # 8 custom exception classes
│   │   │   └── failures.dart           # 10 failure classes (Equatable)
│   │   ├── helpers/
│   │   │   └── check_mode.dart         # Dev/prod mode detection
│   │   ├── services/
│   │   │   └── api_service.dart        # Abstract API interface
│   │   ├── usecase/
│   │   │   └── usecase.dart            # Base UseCase<Type, Params>
│   │   └── utils/
│   │       ├── checko_box_chooser.dart # Interactive multi-select UI
│   │       ├── highlighter.dart        # ANSI color extension
│   │       └── spinners.dart           # Async spinner wrapper
│   ├── data/
│   │   ├── interfaces/
│   │   │   └── command.dart            # Data source contract
│   │   ├── models/
│   │   │   ├── init_config_model.dart  # Config with JSON support
│   │   │   ├── theme_model.dart        # Theme model
│   │   │   ├── widget_file_model.dart  # Widget file model
│   │   │   └── widget_model.dart       # Widget model with JSON
│   │   ├── repository/
│   │   │   └── command_repository_impl.dart  # Either-wrapping adapter
│   │   └── services/
│   │       ├── api_service.dart        # HTTP implementation (109 LOC)
│   │       └── command_interface_impl.dart   # Core logic (276 LOC)
│   └── domain/
│       ├── entities/
│       │   ├── init_config_entity.dart
│       │   ├── theme_entity.dart
│       │   ├── widget_entity.dart
│       │   └── widget_file_entity.dart
│       ├── repository/
│       │   └── command_repository.dart # Abstract contract
│       └── usecases/
│           ├── add_theme_usecase.dart  # Empty placeholder
│           ├── add_usecase.dart
│           ├── init_usecase.dart
│           ├── list_usecase.dart
│           ├── search_usecase.dart     # Empty placeholder
│           └── update_usecase.dart     # Empty placeholder
├── example/test_flutcn/               # Demo Flutter project
│   ├── lib/
│   │   ├── main.dart
│   │   ├── themes/                    # Generated theme files
│   │   └── widgets/                   # Generated widget files
│   └── test/                          # Template test only
├── pubspec.yaml
├── analysis_options.yaml
├── CLAUDE.md
└── README.md
```
