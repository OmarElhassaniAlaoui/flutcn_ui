# Design: Input Widget, Card Widget, Getting Started Page

**Date:** 2026-03-08
**Status:** Approved
**Scope:** v1.4.0

---

## Philosophy

All flutcn widgets follow the shadcn/ui philosophy:
- **Minimal API** — sensible defaults, no required params beyond essentials
- **Theme-driven** — all defaults derived from `ColorScheme` and `TextTheme`
- **Full overridability** — every visual property exposed as an optional named param
- **Escape hatch** — complex style overrides via `*Override` parameters that `.copyWith()` on top of defaults (Flutter's equivalent of the `cn()` utility)
- **Composable** — sub-widgets over monolithic components (especially Card)

---

## Task 1 — `FlutInput` Widget

### Files to create/modify

| File | Repo | Action |
|------|------|--------|
| `registry/new-york/widgets/input.dart` | doc site | Create (registry source — CLI downloads this) |
| `example/lib/widgets/input.dart` | flutcn_ui | Create (example app copy, uses `package:example` imports) |
| `example/lib/preview/previews/input_preview.dart` | flutcn_ui | Create |
| `example/lib/preview/preview_registry.dart` | flutcn_ui | Modify (add `'input'` entry) |
| `content/docs/widgets/input.mdx` | doc site | Create |
| `public/preview/` | doc site | Update (rebuild Flutter web + copy) |

### Widget Design

**Class:** `FlutInput` (extends `StatelessWidget`)
**Wraps:** Flutter's `TextField`

#### Props

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `controller` | `TextEditingController?` | — | Text controller |
| `hintText` | `String?` | — | Placeholder text |
| `label` | `String?` | — | Floating label above field |
| `errorText` | `String?` | — | Error message; triggers error border/color when non-null |
| `helperText` | `String?` | — | Helper text below field |
| `prefixIcon` | `IconData?` | — | Leading icon inside the field |
| `suffixIcon` | `IconData?` | — | Trailing icon inside the field |
| `prefix` | `Widget?` | — | Leading widget (overrides `prefixIcon`) |
| `suffix` | `Widget?` | — | Trailing widget (overrides `suffixIcon`) |
| `obscureText` | `bool` | `false` | Password masking |
| `enabled` | `bool` | `true` | Disabled state |
| `readOnly` | `bool` | `false` | Read-only state |
| `onChanged` | `ValueChanged<String>?` | — | Value change callback |
| `onSubmitted` | `ValueChanged<String>?` | — | Submit callback |
| `onTap` | `VoidCallback?` | — | Tap callback |
| `keyboardType` | `TextInputType?` | — | Keyboard type |
| `textInputAction` | `TextInputAction?` | — | Keyboard action button |
| `maxLines` | `int?` | `1` | Lines (>1 = textarea) |
| `minLines` | `int?` | — | Minimum lines |
| `maxLength` | `int?` | — | Character limit |
| `focusNode` | `FocusNode?` | — | Focus control |
| `autofocus` | `bool` | `false` | Auto-focus on mount |
| `autocorrect` | `bool` | `true` | Autocorrect |
| `textCapitalization` | `TextCapitalization` | `none` | Capitalization |
| `textAlign` | `TextAlign` | `start` | Text alignment |

#### Style override params (cn() equivalent)
| Param | Type | Purpose |
|-------|------|---------|
| `fillColor` | `Color?` | Background fill (default: subtle surface) |
| `borderRadius` | `double?` | Corner radius (default: 8.0) |
| `contentPadding` | `EdgeInsetsGeometry?` | Inner padding override |
| `textStyle` | `TextStyle?` | Input text style override |
| `hintStyle` | `TextStyle?` | Hint text style override |
| `labelStyle` | `TextStyle?` | Label text style override |
| `errorStyle` | `TextStyle?` | Error text style override |
| `focusColor` | `Color?` | Focus border color override (default: `colorScheme.primary`) |
| `errorColor` | `Color?` | Error border/text color override (default: `colorScheme.error`) |
| `borderColor` | `Color?` | Default border color override (default: `colorScheme.outline`) |
| `decorationOverride` | `InputDecoration?` | Full `InputDecoration` that `.copyWith()`s on top of defaults |

#### Default Styling (New York style)
- `OutlineInputBorder` with `BorderRadius.circular(8)`
- Border color: `colorScheme.outline` (rest), `colorScheme.primary` (focus), `colorScheme.error` (error)
- Fill: `colorScheme.surface` with very slight opacity tint
- Text: `textTheme.bodyMedium`
- Hint: `textTheme.bodyMedium` at 60% opacity
- Disabled: 50% opacity overall

#### Convenience constructor
```dart
FlutInput.search({
  // pre-sets prefixIcon: Icons.search, keyboardType: TextInputType.text
})
```

---

## Task 2 — `FlutCard` Widget (composable)

### Files to create/modify

| File | Repo | Action |
|------|------|--------|
| `registry/new-york/widgets/card.dart` | doc site | Create |
| `example/lib/widgets/card.dart` | flutcn_ui | Create |
| `example/lib/preview/previews/card_preview.dart` | flutcn_ui | Create |
| `example/lib/preview/preview_registry.dart` | flutcn_ui | Modify (add `'card'` entry) |
| `content/docs/widgets/card.mdx` | doc site | Create |
| `public/preview/` | doc site | Update |

### Widget Design — 5 composable sub-widgets

#### `FlutCard`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `child` | `Widget` | required | Card content |
| `backgroundColor` | `Color?` | `colorScheme.surface` | Background color |
| `borderColor` | `Color?` | `colorScheme.outline` at 30% | Border color |
| `borderRadius` | `double?` | `12.0` | Corner radius |
| `elevation` | `double?` | `0` | Shadow elevation |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.zero` | Outer padding |
| `decorationOverride` | `BoxDecoration?` | — | Full decoration override (cn() escape hatch) |
| `onTap` | `VoidCallback?` | — | Makes card tappable with InkWell |
| `width` | `double?` | — | Fixed width |
| `height` | `double?` | — | Fixed height |

#### `FlutCardHeader`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `children` | `List<Widget>` | required | Typically `[FlutCardTitle, FlutCardDescription]` |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(24)` | Header padding |
| `spacing` | `double?` | `6.0` | Space between children |

#### `FlutCardTitle`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `text` | `String` | required | Title text |
| `style` | `TextStyle?` | `titleMedium`, `w600` | Text style override |

#### `FlutCardDescription`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `text` | `String` | required | Description text |
| `style` | `TextStyle?` | `bodySmall`, muted color | Text style override |

#### `FlutCardContent`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `child` | `Widget` | required | Body content |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.fromLTRB(24, 0, 24, 24)` | Content padding |

#### `FlutCardFooter`

| Param | Type | Default | Purpose |
|-------|------|---------|---------|
| `children` | `List<Widget>` | required | Footer actions |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.fromLTRB(24, 0, 24, 24)` | Footer padding |
| `alignment` | `MainAxisAlignment?` | `end` | Row alignment |
| `spacing` | `double?` | `8.0` | Space between children |

#### Canonical usage
```dart
FlutCard(
  child: Column(
    children: [
      FlutCardHeader(
        children: [
          FlutCardTitle(text: 'Create project'),
          FlutCardDescription(text: 'Deploy your new project in one-click.'),
        ],
      ),
      FlutCardContent(child: /* form fields */),
      FlutCardFooter(
        children: [
          FlutButton(text: 'Cancel', variant: ButtonVariant.outline, onPressed: () {}),
          FlutButton(text: 'Deploy', onPressed: () {}),
        ],
      ),
    ],
  ),
)
```

---

## Task 3 — Getting Started Doc Page (rewrite)

### File
`content/docs/gettingstarted.mdx` in doc site repo.

### Content Structure

1. **Install the CLI** — `dart pub global activate flutcn_ui` (correct the current wrong `flutter pub add`)
2. **Initialize your project** — `flutcn_ui init` with interactive prompt walkthrough, mention `--default` flag
3. **What init creates** — `flutcn.config.json`, theme directory, `app_theme.dart`, `app_palette.dart`
4. **Add a widget** — `flutcn_ui add button`, mention `--path` option
5. **Browse available widgets** — `flutcn_ui list` (interactive multi-select)
6. **Remove a widget** — `flutcn_ui remove button`
7. **Update widgets** — `flutcn_ui update button` and `--all` flag
8. **Config file explained** — `flutcn.config.json` fields
9. **Lockfile explained** — `flutcn.lock.json` brief mention
10. **Callout boxes** for key notes (already supported in Fumadocs)

---

## Preview Integration

After writing both widgets:
1. Build Flutter web: `cd example && flutter build web --base-href /preview/ --release`
2. Copy to doc site: `cp -r build/web/* /path/to/flutcn-ui-doc/public/preview/`
3. Add `<ComponentPreview name="input" height={450} />` and `<ComponentPreview name="card" height={500} />` to their MDX pages

---

## Execution Order

1. Write `FlutInput` (registry dart + example dart + preview + MDX)
2. Write `FlutCard` (registry dart + example dart + preview + MDX)
3. Rewrite Getting Started page
4. Rebuild Flutter web + copy to doc site
5. Update `meta.json` in doc site to add input and card to sidebar
6. Update `preview_registry.dart` with both new entries
