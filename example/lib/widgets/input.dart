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
