# Input, Card & Getting Started Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add `FlutInput` and `FlutCard` widgets (with registry files, previews, and MDX docs) and rewrite the Getting Started page.

**Architecture:** Each widget lives in two places — the doc site's `registry/new-york/widgets/` (what the CLI downloads) and the example app's `example/lib/widgets/` (uses `package:example` imports). Previews are standalone StatelessWidgets in `example/lib/preview/previews/`. MDX docs live in the doc site's `content/docs/widgets/`. After both widgets are done the Flutter web app is rebuilt and copied to `public/preview/` in the doc site.

**Tech Stack:** Dart/Flutter, Fumadocs MDX, two local repos (`flutcn_ui` + `flutcn-ui-doc`)

**Repo paths:**
- CLI/example repo: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui`
- Doc site repo: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc`

---

## Task 1: `FlutInput` — Registry Widget File

**Files:**
- Create: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/registry/new-york/widgets/input.dart`

This is the source file the CLI downloads when a user runs `flutcn_ui add input`. It uses a relative import (`../themes/app_palette.dart` is NOT needed here — input uses `ColorScheme` from context directly).

**Step 1: Create the registry widget file**

```dart
import 'package:flutter/material.dart';

class FlutInput extends StatelessWidget {
  // Core
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final String? errorText;
  final String? helperText;

  // Icons / affixes
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;

  // Behaviour
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  // Style overrides — Flutter's cn() equivalent
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final Color? focusColor;
  final Color? errorColor;
  final Color? borderColor;

  /// Full escape hatch: merged via copyWith() on top of defaults.
  final InputDecoration? decorationOverride;

  const FlutInput({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = true,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.focusColor,
    this.errorColor,
    this.borderColor,
    this.decorationOverride,
  });

  /// Pre-configured search input with leading search icon.
  const FlutInput.search({
    Key? key,
    TextEditingController? controller,
    String hintText = 'Search...',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    bool enabled = true,
    double? borderRadius,
    Color? fillColor,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decorationOverride,
  }) : this(
          key: key,
          controller: controller,
          hintText: hintText,
          prefixIcon: Icons.search,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          enabled: enabled,
          borderRadius: borderRadius,
          fillColor: fillColor,
          contentPadding: contentPadding,
          decorationOverride: decorationOverride,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final radius = borderRadius ?? 8.0;
    final resolvedBorderColor = borderColor ?? cs.outline;
    final resolvedFocusColor = focusColor ?? cs.primary;
    final resolvedErrorColor = errorColor ?? cs.error;

    Widget? resolvedPrefix = prefix ??
        (prefixIcon != null
            ? Icon(prefixIcon, size: 18,
                color: cs.onSurface.withValues(alpha: 0.5))
            : null);
    Widget? resolvedSuffix = suffix ??
        (suffixIcon != null
            ? Icon(suffixIcon, size: 18,
                color: cs.onSurface.withValues(alpha: 0.5))
            : null);

    final defaultDecoration = InputDecoration(
      hintText: hintText,
      labelText: label,
      errorText: errorText,
      helperText: helperText,
      filled: true,
      fillColor: fillColor ?? cs.surface,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      prefixIcon: resolvedPrefix,
      suffixIcon: resolvedSuffix,
      hintStyle: hintStyle ??
          theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withValues(alpha: 0.4)),
      labelStyle: labelStyle ??
          theme.textTheme.bodyMedium
              ?.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
      errorStyle: errorStyle ??
          theme.textTheme.bodySmall?.copyWith(color: resolvedErrorColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: resolvedBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: resolvedFocusColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: resolvedErrorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: resolvedErrorColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
            color: resolvedBorderColor.withValues(alpha: 0.4)),
      ),
    );

    final decoration = decorationOverride != null
        ? defaultDecoration.copyWith(
            hintText:
                decorationOverride!.hintText ?? defaultDecoration.hintText,
            labelText:
                decorationOverride!.labelText ?? defaultDecoration.labelText,
            errorText:
                decorationOverride!.errorText ?? defaultDecoration.errorText,
            helperText:
                decorationOverride!.helperText ?? defaultDecoration.helperText,
            filled: decorationOverride!.filled ?? defaultDecoration.filled,
            fillColor:
                decorationOverride!.fillColor ?? defaultDecoration.fillColor,
            contentPadding: decorationOverride!.contentPadding ??
                defaultDecoration.contentPadding,
            prefixIcon: decorationOverride!.prefixIcon ??
                defaultDecoration.prefixIcon,
            suffixIcon: decorationOverride!.suffixIcon ??
                defaultDecoration.suffixIcon,
            hintStyle:
                decorationOverride!.hintStyle ?? defaultDecoration.hintStyle,
            labelStyle: decorationOverride!.labelStyle ??
                defaultDecoration.labelStyle,
            errorStyle: decorationOverride!.errorStyle ??
                defaultDecoration.errorStyle,
            enabledBorder: decorationOverride!.enabledBorder ??
                defaultDecoration.enabledBorder,
            focusedBorder: decorationOverride!.focusedBorder ??
                defaultDecoration.focusedBorder,
            errorBorder: decorationOverride!.errorBorder ??
                defaultDecoration.errorBorder,
            focusedErrorBorder: decorationOverride!.focusedErrorBorder ??
                defaultDecoration.focusedErrorBorder,
            disabledBorder: decorationOverride!.disabledBorder ??
                defaultDecoration.disabledBorder,
          )
        : defaultDecoration;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration,
      style: textStyle ?? theme.textTheme.bodyMedium,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      autocorrect: autocorrect,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      keyboardType: obscureText
          ? TextInputType.visiblePassword
          : (maxLines != null && maxLines! > 1
              ? TextInputType.multiline
              : keyboardType),
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
    );
  }
}
```

**Step 2: Verify the file was created**

```bash
ls /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/registry/new-york/widgets/
```
Expected: `avatar.dart  badge.dart  button.dart  input.dart`

**Step 3: Commit in doc site repo**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add registry/new-york/widgets/input.dart
git commit -m "feat: Add FlutInput widget to registry"
```

---

## Task 2: `FlutInput` — Example App Widget File

**Files:**
- Create: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/widgets/input.dart`

Identical logic to the registry file, only the import path changes (no imports needed for input — it only uses `flutter/material.dart`). The registry file and example file are actually identical for `FlutInput` since there's no `app_palette` import. Just copy the same content.

**Step 1: Create example widget file**

Copy the exact same content as Task 1's registry file to:
`/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/widgets/input.dart`

**Step 2: Verify**

```bash
ls /Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/widgets/
```
Expected: `avatar.dart  badge.dart  button.dart  input.dart  theme_toggle_button.dart`

---

## Task 3: `FlutInput` — Preview Widget

**Files:**
- Create: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/preview/previews/input_preview.dart`

**Step 1: Create the preview file**

```dart
import 'package:flutter/material.dart';
import '../../widgets/input.dart';

class InputPreview extends StatelessWidget {
  const InputPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SubsectionTitle(title: 'Default'),
        const SizedBox(height: 16),
        const FlutInput(hintText: 'Enter text...'),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Label'),
        const SizedBox(height: 16),
        const FlutInput(
          label: 'Email',
          hintText: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Icons'),
        const SizedBox(height: 16),
        const FlutInput(
          hintText: 'Enter email',
          prefixIcon: Icons.mail_outline,
        ),
        const SizedBox(height: 12),
        const FlutInput(
          hintText: 'Password',
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          suffixIcon: Icons.visibility_off_outlined,
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Search'),
        const SizedBox(height: 16),
        const FlutInput.search(),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Error State'),
        const SizedBox(height: 16),
        const FlutInput(
          label: 'Username',
          hintText: 'Enter username',
          errorText: 'Username is already taken.',
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Disabled'),
        const SizedBox(height: 16),
        const FlutInput(
          hintText: 'Not available',
          enabled: false,
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Textarea'),
        const SizedBox(height: 16),
        const FlutInput(
          hintText: 'Write a message...',
          maxLines: 4,
          minLines: 3,
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Custom (decorationOverride)'),
        const SizedBox(height: 16),
        FlutInput(
          hintText: 'Custom style',
          decorationOverride: InputDecoration(
            filled: true,
            fillColor: Colors.blue.shade50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final String title;
  const _SubsectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}
```

---

## Task 4: Register `input` in preview registry

**Files:**
- Modify: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/preview/preview_registry.dart`

**Step 1: Update the registry map**

```dart
import 'package:flutter/material.dart';
import 'previews/button_preview.dart';
import 'previews/avatar_preview.dart';
import 'previews/badge_preview.dart';
import 'previews/input_preview.dart';

final Map<String, Widget Function()> previewRegistry = {
  'button': () => const ButtonPreview(),
  'avatar': () => const AvatarPreview(),
  'badge': () => const BadgePreview(),
  'input': () => const InputPreview(),
};
```

---

## Task 5: `FlutInput` — MDX Doc Page

**Files:**
- Create: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/content/docs/widgets/input.mdx`

**Step 1: Create the MDX file**

```mdx
---
title: Input
description: Displays a form input field for collecting user text.
---

<ComponentPreview name="input" height={620} />

# Installation

```bash
flutcn_ui add input
```

# Usage

```dart title="main.dart"
import '../widgets/input.dart';

FlutInput(
  hintText: 'Enter text...',
  onChanged: (value) => print(value),
)
```

## Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| controller | TextEditingController? | — | Controls the text being edited. |
| hintText | String? | — | Placeholder text shown when empty. |
| label | String? | — | Floating label above the field. |
| errorText | String? | — | Error message; triggers red error border when non-null. |
| helperText | String? | — | Helper text shown below the field. |
| prefixIcon | IconData? | — | Leading icon inside the field. |
| suffixIcon | IconData? | — | Trailing icon inside the field. |
| prefix | Widget? | — | Custom leading widget (overrides prefixIcon). |
| suffix | Widget? | — | Custom trailing widget (overrides suffixIcon). |
| obscureText | bool | false | Masks text for password input. |
| enabled | bool | true | When false, disables interaction and dims the field. |
| readOnly | bool | false | When true, prevents editing but allows focus and selection. |
| autofocus | bool | false | Focuses the field automatically on mount. |
| onChanged | ValueChanged\<String\>? | — | Called on every keystroke. |
| onSubmitted | ValueChanged\<String\>? | — | Called when the user submits the field. |
| onTap | VoidCallback? | — | Called when the field is tapped. |
| keyboardType | TextInputType? | — | Type of keyboard to show. |
| textInputAction | TextInputAction? | — | Action button on the keyboard. |
| maxLines | int? | 1 | Number of lines. Set > 1 for a textarea. |
| minLines | int? | — | Minimum number of lines. |
| maxLength | int? | — | Maximum character count. |
| focusNode | FocusNode? | — | Controls focus programmatically. |
| textCapitalization | TextCapitalization | none | Capitalization behaviour. |
| textAlign | TextAlign | start | Horizontal alignment of the text. |
| fillColor | Color? | colorScheme.surface | Background fill color. |
| borderRadius | double? | 8.0 | Corner radius. |
| contentPadding | EdgeInsetsGeometry? | 12h × 10v | Inner padding. |
| textStyle | TextStyle? | bodyMedium | Input text style. |
| hintStyle | TextStyle? | bodyMedium 40% opacity | Hint text style. |
| labelStyle | TextStyle? | bodyMedium 70% opacity | Label text style. |
| errorStyle | TextStyle? | bodySmall error color | Error message style. |
| focusColor | Color? | colorScheme.primary | Border color when focused. |
| errorColor | Color? | colorScheme.error | Border and text color in error state. |
| borderColor | Color? | colorScheme.outline | Border color at rest. |
| decorationOverride | InputDecoration? | — | Full escape hatch merged via copyWith() on top of defaults. |

## Default State

A plain input with placeholder text.

```dart title="input.dart"
FlutInput(
  hintText: 'Enter text...',
)
```

## With Label

The label floats above the field when focused or filled.

```dart title="input.dart"
FlutInput(
  label: 'Email',
  hintText: 'you@example.com',
  keyboardType: TextInputType.emailAddress,
)
```

## With Icons

Use `prefixIcon` or `suffixIcon` for IconData, or `prefix`/`suffix` for custom widgets.

```dart title="input.dart"
FlutInput(
  hintText: 'Enter email',
  prefixIcon: Icons.mail_outline,
)

FlutInput(
  hintText: 'Password',
  obscureText: true,
  prefixIcon: Icons.lock_outline,
  suffixIcon: Icons.visibility_off_outlined,
)
```

## Search

Use `FlutInput.search()` for a pre-configured search field.

```dart title="input.dart"
FlutInput.search(
  onSubmitted: (query) => print(query),
)
```

## Error State

Set `errorText` to trigger the error state. The border and helper text turn red automatically.

```dart title="input.dart"
FlutInput(
  label: 'Username',
  hintText: 'Enter username',
  errorText: 'Username is already taken.',
)
```

## Disabled

Set `enabled: false` to prevent interaction.

```dart title="input.dart"
FlutInput(
  hintText: 'Not available',
  enabled: false,
)
```

## Textarea

Set `maxLines` greater than 1 to create a multi-line text area.

```dart title="input.dart"
FlutInput(
  hintText: 'Write a message...',
  maxLines: 4,
  minLines: 3,
)
```

## Custom Styling

Use individual style params for targeted overrides, or `decorationOverride` for full control.

```dart title="input.dart"
// Targeted override
FlutInput(
  hintText: 'Rounded',
  borderRadius: 24,
  borderColor: Colors.blue,
  focusColor: Colors.blue,
  fillColor: Colors.blue.shade50,
)

// Full escape hatch
FlutInput(
  hintText: 'Custom style',
  decorationOverride: InputDecoration(
    filled: true,
    fillColor: Colors.blue.shade50,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.blue, width: 2),
    ),
  ),
)
```
```

**Step 2: Commit both input files in doc site repo**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add content/docs/widgets/input.mdx
git commit -m "feat: Add Input widget doc page"
```

**Step 3: Commit input files in CLI repo**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui
git add example/lib/widgets/input.dart \
        example/lib/preview/previews/input_preview.dart \
        example/lib/preview/preview_registry.dart
git commit -m "feat: Add FlutInput widget with preview"
```

---

## Task 6: `FlutCard` — Registry Widget File

**Files:**
- Create: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/registry/new-york/widgets/card.dart`

**Step 1: Create the registry widget file**

```dart
import 'package:flutter/material.dart';

/// Main card container. Wrap with FlutCardHeader, FlutCardContent,
/// FlutCardFooter for the full composable layout.
class FlutCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;

  /// Full escape hatch — replaces the default BoxDecoration entirely.
  final BoxDecoration? decorationOverride;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const FlutCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.decorationOverride,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final radius = borderRadius ?? 12.0;

    final decoration = decorationOverride ??
        BoxDecoration(
          color: backgroundColor ?? cs.surface,
          border: Border.all(
            color: borderColor ?? cs.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: (elevation != null && elevation! > 0)
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05 * elevation!),
                    blurRadius: 4 * elevation!,
                    offset: Offset(0, 2 * elevation!),
                  ),
                ]
              : null,
        );

    Widget card = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: card,
          ),
        ),
      );
    }

    return card;
  }
}

/// Top section of a card. Typically contains FlutCardTitle
/// and FlutCardDescription.
class FlutCardHeader extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  const FlutCardHeader({
    super.key,
    required this.children,
    this.padding,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(height: spacing ?? 6),
          ],
        ],
      ),
    );
  }
}

/// Heading text inside FlutCardHeader.
class FlutCardTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const FlutCardTitle({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: style ??
          theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

/// Subtitle / description text inside FlutCardHeader.
class FlutCardDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const FlutCardDescription({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: style ??
          theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
    );
  }
}

/// Body content area of the card.
class FlutCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const FlutCardContent({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: child,
    );
  }
}

/// Bottom action area of the card.
class FlutCardFooter extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment? alignment;
  final double? spacing;

  const FlutCardFooter({
    super.key,
    required this.children,
    this.padding,
    this.alignment,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: alignment ?? MainAxisAlignment.end,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(width: spacing ?? 8),
          ],
        ],
      ),
    );
  }
}
```

**Step 2: Commit**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add registry/new-york/widgets/card.dart
git commit -m "feat: Add FlutCard composable widget to registry"
```

---

## Task 7: `FlutCard` — Example App Widget File

**Files:**
- Create: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/widgets/card.dart`

**Step 1:** Copy the exact same content as Task 6's registry file to `example/lib/widgets/card.dart`. The file is identical — no import changes needed since both use only `flutter/material.dart`.

---

## Task 8: `FlutCard` — Preview Widget

**Files:**
- Create: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/preview/previews/card_preview.dart`

**Step 1: Create the preview file**

```dart
import 'package:flutter/material.dart';
import '../../widgets/card.dart';
import '../../widgets/button.dart';
import '../../widgets/input.dart';

class CardPreview extends StatelessWidget {
  const CardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SubsectionTitle(title: 'Simple Card'),
        const SizedBox(height: 16),
        FlutCard(
          child: FlutCardContent(
            child: Text(
              'A minimal card with just content padding.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Header'),
        const SizedBox(height: 16),
        FlutCard(
          child: Column(
            children: [
              const FlutCardHeader(
                children: [
                  FlutCardTitle(text: 'Card Title'),
                  FlutCardDescription(
                      text: 'A short description of the card.'),
                ],
              ),
              FlutCardContent(
                child: Text(
                  'This is the main content area.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'With Header, Content & Footer'),
        const SizedBox(height: 16),
        FlutCard(
          child: Column(
            children: [
              const FlutCardHeader(
                children: [
                  FlutCardTitle(text: 'Create project'),
                  FlutCardDescription(
                      text: 'Deploy your new project in one-click.'),
                ],
              ),
              const FlutCardContent(
                child: FlutInput(
                  label: 'Project name',
                  hintText: 'my-awesome-app',
                ),
              ),
              FlutCardFooter(
                children: [
                  FlutButton(
                    text: 'Cancel',
                    variant: ButtonVariant.outline,
                    onPressed: () {},
                  ),
                  FlutButton(
                    text: 'Deploy',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Tappable Card'),
        const SizedBox(height: 16),
        FlutCard(
          onTap: () {},
          child: const FlutCardHeader(
            children: [
              FlutCardTitle(text: 'Tap me'),
              FlutCardDescription(
                  text: 'This card is interactive — try tapping it.'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _SubsectionTitle(title: 'Custom (decorationOverride)'),
        const SizedBox(height: 16),
        FlutCard(
          decorationOverride: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const FlutCardHeader(
            children: [
              FlutCardTitle(
                text: 'Gradient Card',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
              FlutCardDescription(
                text: 'Using decorationOverride for full control.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubsectionTitle extends StatelessWidget {
  final String title;
  const _SubsectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    );
  }
}
```

---

## Task 9: Register `card` in preview registry

**Files:**
- Modify: `/Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/lib/preview/preview_registry.dart`

**Step 1: Add card to the map**

```dart
import 'package:flutter/material.dart';
import 'previews/button_preview.dart';
import 'previews/avatar_preview.dart';
import 'previews/badge_preview.dart';
import 'previews/input_preview.dart';
import 'previews/card_preview.dart';

final Map<String, Widget Function()> previewRegistry = {
  'button': () => const ButtonPreview(),
  'avatar': () => const AvatarPreview(),
  'badge': () => const BadgePreview(),
  'input': () => const InputPreview(),
  'card': () => const CardPreview(),
};
```

---

## Task 10: `FlutCard` — MDX Doc Page

**Files:**
- Create: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/content/docs/widgets/card.mdx`

**Step 1: Create the MDX file**

```mdx
---
title: Card
description: A composable container for grouping related content and actions.
---

<ComponentPreview name="card" height={680} />

# Installation

```bash
flutcn_ui add card
```

# Usage

```dart title="main.dart"
import '../widgets/card.dart';

FlutCard(
  child: Column(
    children: [
      FlutCardHeader(
        children: [
          FlutCardTitle(text: 'Card Title'),
          FlutCardDescription(text: 'Card description goes here.'),
        ],
      ),
      FlutCardContent(child: Text('Body content')),
      FlutCardFooter(
        children: [
          FlutButton(text: 'Cancel', variant: ButtonVariant.outline, onPressed: () {}),
          FlutButton(text: 'Save', onPressed: () {}),
        ],
      ),
    ],
  ),
)
```

## Components

FlutCard is built from five composable sub-widgets. Use only the ones you need.

| Widget | Purpose |
| ------ | ------- |
| `FlutCard` | Root container — border, radius, background, optional tap |
| `FlutCardHeader` | Top padding section, stacks children vertically |
| `FlutCardTitle` | Bold heading text |
| `FlutCardDescription` | Muted subtitle text |
| `FlutCardContent` | Body padding area |
| `FlutCardFooter` | Bottom action row, right-aligned by default |

## FlutCard Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| child | Widget | required | Card content. |
| backgroundColor | Color? | colorScheme.surface | Background color. |
| borderColor | Color? | colorScheme.outlineVariant | Border color. |
| borderRadius | double? | 12.0 | Corner radius. |
| elevation | double? | 0 | Shadow depth. |
| padding | EdgeInsetsGeometry? | — | Outer padding around the card. |
| decorationOverride | BoxDecoration? | — | Replaces the default decoration entirely (escape hatch). |
| onTap | VoidCallback? | — | Makes the card tappable with an ink ripple. |
| width | double? | — | Fixed width. |
| height | double? | — | Fixed height. |

## FlutCardHeader Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| children | List\<Widget\> | required | Stacked vertically, typically `[FlutCardTitle, FlutCardDescription]`. |
| padding | EdgeInsetsGeometry? | EdgeInsets.all(24) | Header padding. |
| spacing | double? | 6.0 | Vertical gap between children. |

## FlutCardTitle Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| text | String | required | Title text. |
| style | TextStyle? | titleMedium w600 | Text style override. |

## FlutCardDescription Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| text | String | required | Description text. |
| style | TextStyle? | bodySmall 60% opacity | Text style override. |

## FlutCardContent Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| child | Widget | required | Body content. |
| padding | EdgeInsetsGeometry? | EdgeInsets.fromLTRB(24, 0, 24, 24) | Content padding. |

## FlutCardFooter Properties

| Property | Type | Default | Description |
| -------- | ---- | ------- | ----------- |
| children | List\<Widget\> | required | Action widgets in a row. |
| padding | EdgeInsetsGeometry? | EdgeInsets.fromLTRB(24, 0, 24, 24) | Footer padding. |
| alignment | MainAxisAlignment? | end | Row alignment. |
| spacing | double? | 8.0 | Horizontal gap between children. |

## Simple Card

Just wrap any content — no header or footer required.

```dart title="card.dart"
FlutCard(
  child: FlutCardContent(
    child: Text('Simple content'),
  ),
)
```

## With Header

```dart title="card.dart"
FlutCard(
  child: Column(
    children: [
      FlutCardHeader(
        children: [
          FlutCardTitle(text: 'Notifications'),
          FlutCardDescription(text: 'You have 3 unread messages.'),
        ],
      ),
    ],
  ),
)
```

## With Footer Actions

```dart title="card.dart"
FlutCard(
  child: Column(
    children: [
      FlutCardHeader(
        children: [
          FlutCardTitle(text: 'Create project'),
          FlutCardDescription(text: 'Deploy your new project in one-click.'),
        ],
      ),
      const FlutCardContent(
        child: FlutInput(label: 'Project name', hintText: 'my-app'),
      ),
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

## Tappable Card

Pass `onTap` to make the entire card interactive with an ink ripple effect.

```dart title="card.dart"
FlutCard(
  onTap: () => Navigator.push(context, ...),
  child: FlutCardHeader(
    children: [
      FlutCardTitle(text: 'Open settings'),
      FlutCardDescription(text: 'Tap to navigate.'),
    ],
  ),
)
```

## Custom Styling

Individual overrides for targeted changes:

```dart title="card.dart"
FlutCard(
  backgroundColor: Colors.blue.shade50,
  borderColor: Colors.blue,
  borderRadius: 20,
  elevation: 2,
  child: ...,
)
```

Full decoration override for complete control:

```dart title="card.dart"
FlutCard(
  decorationOverride: BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: FlutCardHeader(
    children: [
      FlutCardTitle(
        text: 'Premium',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      FlutCardDescription(
        text: 'Upgrade your plan.',
        style: const TextStyle(color: Colors.white70),
      ),
    ],
  ),
)
```
```

**Step 2: Commit in doc site repo**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add content/docs/widgets/card.mdx
git commit -m "feat: Add Card widget doc page"
```

**Step 3: Commit card files in CLI repo**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui
git add example/lib/widgets/card.dart \
        example/lib/preview/previews/card_preview.dart \
        example/lib/preview/preview_registry.dart
git commit -m "feat: Add FlutCard composable widget with preview"
```

---

## Task 11: Rebuild Flutter Web & Copy to Doc Site

**Step 1: Build Flutter web from example dir**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui/example
flutter build web --base-href /preview/ --release
```

Expected output ends with: `✓ Built build/web`

**Step 2: Clear old preview in doc site**

```bash
rm -rf /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/public/preview/*
```

**Step 3: Copy new build**

```bash
cp -r /Users/omar/Developer/Mobile/Flutter/flutcn_ui/example/build/web/. \
      /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/public/preview/
```

**Step 4: Verify**

```bash
ls /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/public/preview/
```
Expected: `flutter.js  flutter_bootstrap.js  index.html  main.dart.js  ...`

**Step 5: Test locally**

Run the doc site dev server:
```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
pnpm dev
```

Open `http://localhost:3000/docs/widgets/input` and `http://localhost:3000/docs/widgets/card` — verify the ComponentPreview iframes load the Flutter widgets.

Also test the iframe URLs directly:
- `http://localhost:3000/preview/index.html?widget=input&theme=light`
- `http://localhost:3000/preview/index.html?widget=card&theme=dark`

**Step 6: Commit Flutter web build in doc site repo**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add public/preview/
git commit -m "feat: Rebuild Flutter web preview with input and card widgets"
```

---

## Task 12: Rewrite Getting Started Doc Page

**Files:**
- Modify: `/Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc/content/docs/gettingstarted.mdx`

**Step 1: Replace with the corrected and complete content**

```mdx
---
title: Getting Started
description: Learn how to install and use flutcn_ui in your Flutter project.
icon: Rocket
---

## 1. Install the CLI

flutcn_ui is a command-line tool — not a Flutter package. Install it globally with the Dart pub tool:

```bash
dart pub global activate flutcn_ui
```

Make sure your Dart pub global bin is on your PATH. Add the following to your shell profile if needed:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

## 2. Initialize Your Project

Run `init` from inside your Flutter project directory (where `pubspec.yaml` lives):

```bash
flutcn_ui init
```

You will be asked a few questions:

```
Which path do you choose for theme? (lib/themes)
Which path do you choose for widgets? (lib/widgets)
Which style do you want to use? (new-york | default)
Which color scheme do you want to use? (zinc)
Install Google Fonts? (y/N)
```

<Callout className="bg-blue-50 border-blue-600 dark:border-blue-900 dark:bg-blue-950 mb-6 [&_code]:bg-blue-100 dark:[&_code]:bg-blue-900">
  **Tip:** Use `flutcn_ui init --default` to skip all prompts and use the default configuration.
</Callout>

### What init creates

- `flutcn.config.json` — configuration file at your project root
- `lib/themes/app_theme.dart` — light and dark ThemeData definitions
- `lib/themes/app_palette.dart` — color palette for your chosen base color
- `lib/widgets/` — empty directory where widgets will be installed

`flutcn.config.json` looks like this:

```json
{
  "widgetsPath": "lib/widgets",
  "themePath": "lib/themes",
  "style": "new-york",
  "baseColor": "zinc"
}
```

## 3. Add a Widget

Install any widget from the registry:

```bash
flutcn_ui add button
```

The widget source file is written to your configured `widgetsPath`. Import and use it directly — the code is yours to modify.

```dart
import '../widgets/button.dart';

FlutButton(
  text: 'Click me',
  variant: ButtonVariant.primary,
  onPressed: () {},
)
```

To install to a custom directory without changing your config:

```bash
flutcn_ui add button --path lib/ui/components
```

## 4. Browse Available Widgets

See all available widgets and their install status:

```bash
flutcn_ui list
```

This opens an interactive multi-select interface. Widgets show one of three statuses:

- `[installed]` — local file matches the registry version
- `[modified locally]` — local file has been changed since install
- `[installed - untracked]` — file exists but was not installed through flutcn_ui

## 5. Remove a Widget

```bash
flutcn_ui remove button
```

Or run `flutcn_ui remove` with no arguments for an interactive multi-select. Use `--force` to skip the confirmation prompt.

## 6. Update a Widget

Re-download a widget from the registry, overwriting your local copy:

```bash
flutcn_ui update button
```

Update all installed widgets at once:

```bash
flutcn_ui update --all
```

The update command shows a per-widget status:
- `✔ up-to-date` — content unchanged
- `↑ updated` — new version downloaded
- `⚡ newly tracked` — added to the lockfile

## 7. The Lockfile

`flutcn.lock.json` is created alongside `flutcn.config.json` and tracks the SHA-256 hash of every installed widget. Commit it to version control so your team can detect local modifications with `flutcn_ui list`.

```json
{
  "lockfileVersion": 1,
  "widgets": {
    "button": {
      "style": "new-york",
      "contentHash": "sha256:a3f5e8c9...",
      "installedAt": "2026-03-08T10:30:00.000Z"
    }
  }
}
```
```

**Step 2: Commit**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
git add content/docs/gettingstarted.mdx
git commit -m "docs: Rewrite Getting Started page with correct CLI instructions"
```

---

## Task 13: Final Verification

**Step 1: Run dart analyze on CLI repo (no errors)**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui
dart analyze
```
Expected: `No issues found!`

**Step 2: Run Flutter analyze on example app**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui/example
flutter analyze
```
Expected: `No issues found!`

**Step 3: Run existing CLI tests**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui
dart test
```
Expected: `71 tests passed`

**Step 4: Verify doc site builds**

```bash
cd /Users/omar/Developer/Web/Nextjs-projects/flutcn-ui-doc
pnpm build
```
Expected: No errors, static export completes.

**Step 5: Final commit summary in CLI repo**

```bash
cd /Users/omar/Developer/Mobile/Flutter/flutcn_ui
git log --oneline -8
```

You should see commits for: card widget, input widget, preview registry, and design doc.
