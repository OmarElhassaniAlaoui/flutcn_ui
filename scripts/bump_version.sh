#!/bin/bash
set -e

# Usage: ./scripts/bump_version.sh <major|minor|patch>
# Bumps the version in pubspec.yaml and prints next steps.

PUBSPEC="pubspec.yaml"
BUMP_TYPE="${1:-patch}"

if [[ ! -f "$PUBSPEC" ]]; then
  echo "Error: $PUBSPEC not found. Run this from the project root."
  exit 1
fi

# Extract current version
CURRENT=$(grep '^version:' "$PUBSPEC" | sed 's/version: //')
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP_TYPE" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
  *)
    echo "Usage: $0 <major|minor|patch>"
    echo ""
    echo "  major  Breaking changes (CLI interface, config schema)"
    echo "  minor  New features, commands, flags (backward-compatible)"
    echo "  patch  Bug fixes, internal refactors"
    exit 1
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Update pubspec.yaml
sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"

echo "Bumped version: $CURRENT -> $NEW_VERSION"
echo ""
echo "Next steps:"
echo "  1. Update CHANGELOG.md with a [${NEW_VERSION}] section"
echo "  2. git add pubspec.yaml CHANGELOG.md"
echo "  3. git commit -m \"chore: Prepare release v${NEW_VERSION}\""
echo "  4. Open PR to main (or merge release branch)"
