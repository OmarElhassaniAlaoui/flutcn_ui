# Flutcn UI Project Analysis

> **Version analyzed:** 1.2.0+ | **Dart files:** 47 | **LOC (lib/src/):** ~1,300 | **Branch:** dev

## 1. Project Overview

**flutcn_ui** is a command-line tool for Flutter, inspired by `shadcn/ui`. It fetches pre-built, customizable UI components from a remote registry (`https://flutcnui.netlify.app`) and integrates them into Flutter projects with theme support.

**Core capabilities:**
- `init` — Set up project with `flutcn.config.json`, generate theme files
- `add` — Download and install widgets (single or batch)
- `list` — Browse and install available widgets interactively
- `remove` — Uninstall widgets by deleting local `.dart` files
- `update` — Refresh installed widgets from the registry

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
| `crypto` | `^3.0.3` | SHA-256 hashing for widget content tracking |
| `dartz` | `^0.10.1` | `Either<L, R>` functional error handling |
| `equatable` | `^2.0.7` | Value equality for entities |
| `get_it` | `^9.0.0` | Service locator / DI container |
| `http` | `^1.3.0` | HTTP client for registry API |
| `io` | `^1.0.5` | Console I/O utilities |
| `path` | `^1.8.0` | Cross-platform path manipulation |
| `prompts` | `^2.0.0` | Interactive CLI prompts |

### Dev

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | `^2.4.6` | Code generation (prepared, not actively used) |
| `lints` | `^5.0.0` | `package:lints/recommended.yaml` lint rules |
| `test` | `^1.24.0` | Test framework — 64 unit tests for entities, repository, use cases, and lockfile manager |

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
- Shows install status markers per widget using lockfile + local file detection:
  - `[installed]` (green) — local file matches lockfile hash
  - `[modified locally]` (yellow) — local file differs from lockfile hash
  - `[installed - untracked]` (dim) — local file exists but not in lockfile
- Shows interactive multi-select interface
- Checks for existing files before writing (overwrite/skip/cancel)
- Records installed widgets in lockfile after download
- Prints color-coded summary: green (success), yellow (skipped), red (failed)

### `remove` (added in v1.2.0)
- **Direct mode:** `flutcn_ui remove button` — deletes widget file with confirmation prompt
- **Interactive mode:** `flutcn_ui remove` — shows multi-select of installed widgets
- `--force` / `-f` flag to skip confirmation prompt
- Checks widget exists at `$widgetsPath/$widgetName.dart` before deleting
- Color-coded output: green (removed), red (errors), yellow (not found)

### `update` (added in v1.2.0)
- **Direct mode:** `flutcn_ui update button` — re-downloads widget from registry
- **Interactive mode:** `flutcn_ui update` — shows multi-select of installed widgets
- `--all` / `-a` flag to update all installed widgets without selection
- Checks widget exists locally before fetching from registry
- Compares fetched content hash against lockfile to detect changes
- Color-coded per-widget status output:
  - Green `✔ up-to-date` — content hash unchanged
  - Cyan `↑ updated` — content hash changed, file overwritten
  - Yellow `⚡ newly tracked` — widget wasn't in lockfile, now tracked
- Records updated hash in lockfile after each widget

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
- HTTP requests have 30-second timeout, offline/DNS failures detected and reported with friendly messages

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

- Created by `init` command (written last, after theme fetch succeeds — prevents broken half-initialized state)
- Required before `add` or `list` commands
- Entity (`InitConfigEntity`) supports JSON serialization
- **Schema validation** — `fromJson()` validates all required fields with type checks and clear error messages
- **Centralized reading** — `ConfigReader` utility handles file existence, JSON parsing, and validation errors

## 7. Widget Versioning (Lockfile)

**File:** `flutcn.lock.json` (project root, alongside `flutcn.config.json`)

```json
{
  "lockfileVersion": 1,
  "widgets": {
    "button": {
      "style": "new-york",
      "contentHash": "sha256:a3f5e8c9...",
      "installedAt": "2026-02-14T10:30:00.000Z"
    }
  }
}
```

**How it works:**
- `init` creates an empty lockfile
- `add` / `list` record each widget's SHA-256 content hash after download
- `remove` deletes the widget entry from the lockfile
- `update` compares fetched content hash against lockfile to show up-to-date vs updated status
- `list` reads lockfile + local files to show `[installed]`, `[modified locally]`, or `[installed - untracked]` markers

**Implementation:** `LockfileManager` static utility class (`lib/src/core/utils/lockfile_manager.dart`) — mirrors the `ConfigReader` pattern. Methods: `readLockfile()`, `writeLockfile()`, `computeHash()`, `recordWidget()`, `removeWidget()`, `getWidget()`, `isUpToDate()`, `lockfileExists()`.

**Design decision:** Lockfile is a CLI utility concern (presentation layer), not a domain concept. No new entities, models, or repository changes needed.

## 8. Code Quality — Strengths

- **Clean Architecture** — proper layer separation, no layer violations
- **Functional error handling** — `Either<Failure, T>` consistently used across all use cases
- **Comprehensive failure types** — 10 specific failure classes for different error scenarios
- **Granular exception mapping** — repository catches `OfflineException`, `ThemeNotFoundException`, `ServerException`, `ComponentNotFoundException`, `InvalidConfigFileException` and maps each to typed `Failure`
- **Config validation** — `fromJson()` validates required fields with type checks and clear error messages
- **Widget versioning** — SHA-256 content hashing tracks installed widget state in lockfile, enabling change detection across `update` and `list` commands
- **Network resilience** — 30s timeouts, offline detection (catches `SocketException` + `http.ClientException`), friendly error messages in spinners
- **Cross-platform CLI UX** — platform-aware keyboard handling (Windows vs. Mac/Linux key codes)
- **Visual feedback** — spinners with friendly error messages, color-coded output, interactive selection
- **Singleton DI** — lazy registration prevents unnecessary initialization
- **CI/CD pipeline** — automated analysis, release tagging, and pub.dev publishing
- **Unit tests** — 64 tests covering entities, repository exception mapping, use case passthrough, and lockfile manager

## 9. Bugs & Issues (Fixed)

All bugs identified have been resolved in v1.1.3, v1.1.4, and v1.1.5:

### ~~Bug: API Service `get()` missing base URL~~ — Fixed in v1.1.3
**File:** `lib/src/data/services/api_service.dart`

`get()` now correctly prepends `baseUrl`, consistent with all other HTTP methods.

### ~~Bug: Variable name typo~~ — Fixed in v1.1.3
**File:** `lib/src/data/services/command_interface_impl.dart`

`widgetsPaht` renamed to `widgetsPath`.

### ~~Issue: Filename typos~~ — Fixed in v1.1.3
| Old Name | New Name |
|----------|----------|
| `qestions.dart` | `questions.dart` |
| `app_pallete.dart` | `app_palette.dart` |
| `checko_box_chooser.dart` | `checkbox_chooser.dart` |

### ~~Issue: Error handling inconsistency~~ — Fixed in v1.1.3
`ListUseCase` now returns `Either<Failure, List<WidgetEntity>>` consistently with `InitUseCase` and `AddUseCase`. Callers in `add.dart` and `list.dart` unwrap with `.fold()`.

### ~~Issue: google_fonts in CLI dependencies~~ — Fixed in v1.1.4
`google_fonts` was listed as a CLI dependency but never imported — it's only written as a string to the user's `pubspec.yaml`. Removed to fix Dart SDK version conflict in CI.

### ~~Bug: InitUseCase silently discarding failures~~ — Fixed in v1.1.5
**File:** `lib/src/domain/usecases/init_usecase.dart`

`InitUseCase.call()` did `await repository.initializeProject()` but discarded the `Either` result and always returned `Right(unit)`. Offline errors, theme-not-found errors, etc. were silently swallowed. Now passes through `Either` directly like `AddUseCase` and `ListUseCase`.

### ~~Bug: ClientException not caught for offline detection~~ — Fixed in v1.1.5
**File:** `lib/src/data/services/api_service.dart`

The Dart `http` package wraps `SocketException` in `ClientException` for DNS/network failures. Only catching `SocketException` missed these. Added `on http.ClientException` catch in `_withErrorHandling()`.

### ~~Bug: Init shows success after theme fetch failure~~ — Fixed in v1.1.5
**Files:** `lib/src/data/services/command_interface_impl.dart`, `lib/src/data/repository/command_repository_impl.dart`

Two root causes: (1) blanket `catch(e) { throw InitializationException(); }` converted all exceptions to generic type, preventing specific exception routing in repository; (2) config file was created before theme fetch, leaving broken half-initialized state. Fixed by removing blanket catch and moving config creation to last step.

### ~~Bug: Directory check for config file always false~~ — Fixed in v1.1.5
**File:** `bin/commands/init.dart`

`Directory('flutcn.config.json').existsSync()` always returned false because it checked for a directory, not a file. Replaced with `ConfigReader.configExists()`.

## 10. Unused & Commented-Out Code

### Empty use case files (placeholders)
- `lib/src/domain/usecases/add_theme_usecase.dart` — empty
- `lib/src/domain/usecases/search_usecase.dart` — empty

### Legacy constant
- `lib/src/core/constants/app_constants.dart` — contains `baseUrl = 'https://flutcn.com/api/v1'` which is never referenced

### Commented-out state management
State management selection is prepared across multiple files but fully commented out:
- `InitConfigEntity` — `stateManagement` field commented
- `CommandInterfaceImpl` — switch statement for bloc/provider/riverpod commented
- `InitCommand` — state management prompt commented

## 11. Test Coverage

**Current state: 64 unit tests (40 in v1.1.5, 7 added in v1.2.0, 17 for lockfile manager)**

| Test file | Tests | Coverage |
|-----------|-------|----------|
| `test/domain/entities/init_config_entity_test.dart` | 12 | `fromJson` validation, defaults, round-trip, equality |
| `test/data/repository/command_repository_impl_test.dart` | 15 | Exception→Failure mapping for `initializeProject`, `add`, `list` |
| `test/domain/usecases/init_usecase_test.dart` | 4 | Success + failure propagation |
| `test/domain/usecases/add_usecase_test.dart` | 3 | Success + failure propagation |
| `test/domain/usecases/list_usecase_test.dart` | 4 | Success + empty list + failure propagation |
| `test/domain/usecases/remove_usecase_test.dart` | 3 | Success + ComponentNotFoundFailure + GenericFailure |
| `test/domain/usecases/update_usecase_test.dart` | 4 | Success + OfflineFailure + ComponentNotFoundFailure + ServerFailure |
| `test/core/utils/lockfile_manager_test.dart` | 17 | computeHash, readLockfile, writeLockfile, recordWidget, removeWidget, getWidget, isUpToDate, lockfileExists |
| **Mock classes** | — | `test/mocks/mock_command_interface.dart`, `test/mocks/mock_command_repository.dart` |

**Not yet tested:**
- CLI commands (integration tests with mock DI)
- API service (HTTP response handling, timeout/offline behavior)
- `ConfigReader` (file I/O, JSON parsing errors)
- `CommandInterfaceImpl` (file creation, theme fetching)

## 12. CI/CD Pipeline

### Workflows (`.github/workflows/`)

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | PR to `main` or `dev` | Lint, analyze, format check |
| `release.yml` | Push to `main` | Extract version, create git tag & GitHub release |
| `publish.yml` | Tag push `v*` | Verify version, analyze, publish to pub.dev |

**Notes:**
- CI excludes `example/` during `dart pub get` (Flutter project requires Flutter SDK, CI only has Dart)
- `release.yml` skips if tag already exists (relevant when using git flow which creates tags locally)
- Publish requires `PUB_CREDENTIALS` GitHub secret for pub.dev authentication
- **Known limitation:** Tags created by `GITHUB_TOKEN` in `release.yml` do not trigger `publish.yml` (GitHub prevents workflow chaining). Workaround: manually delete and re-push the tag, or use a Personal Access Token (PAT) in `release.yml`

### Version Bump Script
`scripts/bump_version.sh` — updates version in `pubspec.yaml` and creates a CHANGELOG entry.

## 13. Improvement Recommendations

### ~~Priority 1 — Fix Bugs~~ — All Done (v1.1.3, v1.1.4, v1.1.5)
- [x] Fix `get()` method in `HttpServiceImpl` to prepend `baseUrl`
- [x] Fix `widgetsPaht` typo in `command_interface_impl.dart`
- [x] Rename misspelled files (`qestions.dart`, `app_pallete.dart`, `checko_box_chooser.dart`)
- [x] Fix `ListUseCase` to return `Either` instead of throwing
- [x] Remove unused `google_fonts` from CLI dependencies
- [x] Fix `InitUseCase` silently discarding repository failures
- [x] Fix `ClientException` not caught for offline detection
- [x] Fix init showing success after theme fetch failure
- [x] Fix `Directory('flutcn.config.json')` check always returning false

### Priority 2 — Code Hygiene
- [ ] Remove empty use case files or implement them (`add_theme_usecase.dart`, `search_usecase.dart`)
- [ ] Remove unused `AppConstants.baseUrl`
- [ ] Either implement state management feature or remove commented code

### ~~Priority 3 — Reliability~~ — All Done (v1.1.5)
- [x] Add unit tests for use cases and repositories (40 tests)
- [x] Add config file schema validation (`fromJson()` + `ConfigReader`)
- [x] Add offline fallback / graceful error when registry is unreachable (timeouts, `ClientException` catch, friendly messages)

### Priority 4 — More Tests
- [ ] Integration tests for CLI commands (mock DI container)
- [ ] `ConfigReader` tests (file I/O, JSON parsing errors)
- [ ] `CommandInterfaceImpl` tests (file creation, HTTP status handling)
- [ ] `HttpServiceImpl` tests (timeout, offline detection)

### Priority 5 — Features
- [x] `remove` command — uninstall widgets (v1.2.0)
- [x] `update` command — update installed widgets (v1.2.0)
- [x] Widget versioning — track installed versions via `flutcn.lock.json` with SHA-256 content hashes
- [ ] `--path` option on `add` command — override default widget directory
- [ ] Dependency resolution for widget inter-dependencies

## 14. File Structure

```
flutcn_ui/
├── .github/workflows/
│   ├── ci.yml                         # PR analysis & format checks
│   ├── release.yml                    # Auto-tag & GitHub release on main push
│   └── publish.yml                    # Publish to pub.dev on tag push
├── bin/
│   ├── flutcn_ui.dart                 # CLI entry point
│   ├── injection_container.dart       # GetIt DI setup
│   └── commands/
│       ├── init.dart                  # Init command (131 LOC)
│       ├── add.dart                   # Add command (186 LOC)
│       ├── list.dart                  # List command (164 LOC)
│       ├── remove.dart               # Remove command (v1.2.0)
│       └── update.dart               # Update command (v1.2.0)
├── lib/src/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart     # API URLs (dev + prod)
│   │   │   ├── app_constants.dart     # Legacy unused constant
│   │   │   ├── file_paths.dart        # Default widget/theme paths
│   │   │   └── questions.dart         # CLI prompt definitions
│   │   ├── errors/
│   │   │   ├── exceptions.dart        # 8 custom exception classes
│   │   │   └── failures.dart          # 10 failure classes (Equatable)
│   │   ├── helpers/
│   │   │   └── check_mode.dart        # Dev/prod mode detection
│   │   ├── services/
│   │   │   └── api_service.dart       # Abstract API interface
│   │   ├── usecase/
│   │   │   └── usecase.dart           # Base UseCase<Type, Params>
│   │   └── utils/
│   │       ├── checkbox_chooser.dart  # Interactive multi-select UI
│   │       ├── config_reader.dart     # Centralized config file reading/validation
│   │       ├── highlighter.dart       # ANSI color extension
│   │       ├── lockfile_manager.dart  # Lock file utility (read/write/hash/track)
│   │       └── spinners.dart          # Async spinner wrapper with friendly errors
│   ├── data/
│   │   ├── interfaces/
│   │   │   └── command.dart           # Data source contract
│   │   ├── models/
│   │   │   ├── init_config_model.dart # Config with JSON support
│   │   │   ├── theme_model.dart       # Theme model
│   │   │   ├── widget_file_model.dart # Widget file model
│   │   │   └── widget_model.dart      # Widget model with JSON
│   │   ├── repository/
│   │   │   └── command_repository_impl.dart  # Either-wrapping adapter
│   │   └── services/
│   │       ├── api_service.dart       # HTTP implementation with timeout/offline detection
│   │       └── command_interface_impl.dart   # Core logic (init, add, list, remove, update)
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
│           ├── remove_usecase.dart     # Remove use case (v1.2.0)
│           ├── search_usecase.dart     # Empty placeholder
│           └── update_usecase.dart     # Update use case (v1.2.0)
├── example/                           # Demo Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── home.dart                  # Widget showcase screen
│   │   ├── theme_notifier.dart        # Dark/light theme toggle
│   │   ├── showcase/                  # Widget demo screens
│   │   ├── themes/                    # Generated theme files
│   │   └── widgets/                   # Generated widget files
│   └── test/                          # Template test only
├── test/
│   ├── mocks/
│   │   ├── mock_command_interface.dart    # Manual mock for CommandInterface
│   │   └── mock_command_repository.dart   # Manual mock for CommandRepository
│   ├── core/utils/
│   │   └── lockfile_manager_test.dart         # 17 lockfile manager tests
│   ├── data/repository/
│   │   └── command_repository_impl_test.dart  # 15 exception mapping tests
│   └── domain/
│       ├── entities/
│       │   └── init_config_entity_test.dart   # 12 validation tests
│       └── usecases/
│           ├── init_usecase_test.dart          # 4 tests
│           ├── add_usecase_test.dart           # 3 tests
│           ├── list_usecase_test.dart          # 4 tests
│           ├── remove_usecase_test.dart        # 3 tests (v1.2.0)
│           └── update_usecase_test.dart        # 4 tests (v1.2.0)
├── scripts/
│   └── bump_version.sh                # Version bump utility
├── reports/
│   └── project_analysis.md            # This file
├── pubspec.yaml
├── CHANGELOG.md
├── CLAUDE.md
├── analysis_options.yaml
└── README.md
```
