# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
