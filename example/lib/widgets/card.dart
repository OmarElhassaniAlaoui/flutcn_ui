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
