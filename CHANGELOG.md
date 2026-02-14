# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2026-02-14

### Added

- Widget versioning via `flutcn.lock.json` — tracks installed widgets with SHA-256 content hashes
  - `init` creates empty lockfile alongside config
  - `add` / `list` record widget hashes after download
  - `remove` deletes widget entry from lockfile
  - `update` compares hashes: shows up-to-date, updated, or newly tracked per widget
  - `list` shows install status: [installed], [modified locally], [installed - untracked]
- `crypto` dependency for SHA-256 hashing
- `LockfileManager` utility class (`lib/src/core/utils/lockfile_manager.dart`)
- 17 new unit tests for lockfile manager (64 total)
- Updated README with remove, update, and widget versioning documentation

## [1.2.0] - 2026-02-14

### Added

- `remove` command — uninstall widgets by deleting local `.dart` files
  - Direct mode: `flutcn_ui remove button`
  - Interactive mode: `flutcn_ui remove` (multi-select from installed widgets)
  - `--force` / `-f` flag to skip confirmation prompt
- `update` command — refresh installed widgets from the registry
  - Direct mode: `flutcn_ui update button`
  - Interactive mode: `flutcn_ui update` (multi-select from installed widgets)
  - `--all` / `-a` flag to update all installed widgets
- Unit tests for `remove` and `update` use cases (47 total tests)

## [1.1.5] - 2026-02-12

### Fixed

- Fix `InitUseCase` silently discarding repository failures (always returned success)
- Catch `http.ClientException` for DNS/network failures (shows friendly offline message)
- Remove blanket try-catch in `init()` that swallowed all error context
- Move config file creation to last step in init (prevents broken half-initialized state)
- Fix `Directory('flutcn.config.json')` check that always returned false

### Added

- Config field validation with clear error messages in `fromJson()`
- Centralized `ConfigReader` utility replacing inline JSON parsing in commands
- HTTP request timeouts (30 seconds) and offline detection
- Granular exception-to-failure mapping in repository
- Friendly error messages in spinner helper
- Unit tests for entities, repository, and use cases (40 tests)

### Changed

- Use cases pass through `Either` from repositories (no unwrapping in domain layer)

## [1.1.4] - 2026-02-11

### Fixed

- Remove `google_fonts` from CLI dependencies (not used directly, caused Dart SDK version conflict in CI)

## [1.1.3] - 2026-02-11

### Fixed

- Make `ApiService.get()` prepend `baseUrl` consistently with other HTTP methods
- Correct `widgetsPath` parameter typo in config file creation
- Rename misspelled files: `qestions.dart`, `checko_box_chooser.dart`, `app_pallete.dart`
- Make `ListUseCase` return `Either<Failure, T>` instead of throwing exceptions

### Added

- CI/CD workflows for automated releases and pub.dev publishing
- Version bump script (`scripts/bump_version.sh`)
- Dark/light theme toggle in example app

### Changed

- Widget URL construction uses relative paths instead of hardcoded base URLs
- Migrated deprecated Flutter APIs in example app (Material 3)

## [1.1.2] - 2025-03-28

### Changed

- Improve output formatting and cleanup code in commands and constants

## [1.1.1] - 2025-03-27

### Fixed

- Remove development mode checks and use production URLs consistently

### Changed

- Update ListCommand to include style in widget link

## [1.1.0] - 2025-03-25

### Added

- Interactive multi-widget selection in `list` command
- File overwrite confirmation prompts
- Skipped downloads tracking
- Enhanced conflict resolution system

### Changed

- Improved README documentation
- Better error handling for network operations
- Color-coded terminal output

### Fixed

- Concurrent spinner display issues
- File existence check reliability
