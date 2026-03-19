import 'package:flutter/material.dart' hide Badge;

/// Badge variants following shadcn UI badge patterns
enum BadgeVariant {
  primary,
  secondary,
  destructive,
  outline,
  custom,
}

class FlutBadge extends StatelessWidget {
  final String? text;
  final BadgeVariant variant;
  final IconData? icon;
  final Widget? child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? iconSize;
  final double? gap;

  const FlutBadge({
    super.key,
    this.text,
    this.variant = BadgeVariant.primary,
    this.icon,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.iconSize,
    this.gap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color bg;
    final Color fg;
    final Color bc;
    final double bw;

    switch (variant) {
      case BadgeVariant.primary:
        bg = backgroundColor ?? colorScheme.primary;
        fg = foregroundColor ?? colorScheme.onPrimary;
        bc = borderColor ?? Colors.transparent;
        bw = borderWidth ?? 0;
      case BadgeVariant.secondary:
        bg = backgroundColor ?? colorScheme.secondary;
        fg = foregroundColor ?? colorScheme.onSecondary;
        bc = borderColor ?? Colors.transparent;
        bw = borderWidth ?? 0;
      case BadgeVariant.destructive:
        bg = backgroundColor ?? colorScheme.error;
        fg = foregroundColor ?? colorScheme.onError;
        bc = borderColor ?? Colors.transparent;
        bw = borderWidth ?? 0;
      case BadgeVariant.outline:
        bg = backgroundColor ?? Colors.transparent;
        fg = foregroundColor ?? colorScheme.onSurface;
        bc = borderColor ?? colorScheme.outline;
        bw = borderWidth ?? 1.0;
      case BadgeVariant.custom:
        bg = backgroundColor ?? colorScheme.surface;
        fg = foregroundColor ?? colorScheme.onSurface;
        bc = borderColor ?? Colors.transparent;
        bw = borderWidth ?? 0;
    }

    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 2);
    final effectiveFontSize = fontSize ?? 12.0;
    final effectiveFontWeight = fontWeight ?? FontWeight.w600;
    final effectiveIconSize = iconSize ?? 12.0;
    final effectiveGap = gap ?? 4.0;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius ?? 9999.0),
        border:
            bw > 0 ? Border.all(color: bc, width: bw) : null,
      ),
      child: child ??
          _buildContent(
            fg,
            effectiveFontSize,
            effectiveFontWeight,
            effectiveIconSize,
            effectiveGap,
          ),
    );
  }

  Widget _buildContent(
    Color textColor,
    double fontSize,
    FontWeight fontWeight,
    double iconSize,
    double gap,
  ) {
    final List<Widget> children = [];

    if (icon != null) {
      children.add(Icon(icon, size: iconSize, color: textColor));
      if (text != null) children.add(SizedBox(width: gap));
    }

    if (text != null) {
      children.add(Text(
        text!,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: 1.0,
        ),
      ));
    }

    if (children.length == 1) return children.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Helper class with static factory methods for common badge variants
class Badge {
  static Widget primary({
    String? text,
    IconData? icon,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    double? gap,
  }) {
    return FlutBadge(
      text: text,
      variant: BadgeVariant.primary,
      icon: icon,
      child: child,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      iconSize: iconSize,
      gap: gap,
    );
  }

  static Widget secondary({
    String? text,
    IconData? icon,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    double? gap,
  }) {
    return FlutBadge(
      text: text,
      variant: BadgeVariant.secondary,
      icon: icon,
      child: child,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      iconSize: iconSize,
      gap: gap,
    );
  }

  static Widget destructive({
    String? text,
    IconData? icon,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    double? gap,
  }) {
    return FlutBadge(
      text: text,
      variant: BadgeVariant.destructive,
      icon: icon,
      child: child,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: borderRadius,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      iconSize: iconSize,
      gap: gap,
    );
  }

  static Widget outline({
    String? text,
    IconData? icon,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    double? gap,
  }) {
    return FlutBadge(
      text: text,
      variant: BadgeVariant.outline,
      icon: icon,
      child: child,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      iconSize: iconSize,
      gap: gap,
    );
  }

  static Widget custom({
    String? text,
    IconData? icon,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSize,
    double? gap,
  }) {
    return FlutBadge(
      text: text,
      variant: BadgeVariant.custom,
      icon: icon,
      child: child,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      fontSize: fontSize,
      fontWeight: fontWeight,
      iconSize: iconSize,
      gap: gap,
    );
  }
}
