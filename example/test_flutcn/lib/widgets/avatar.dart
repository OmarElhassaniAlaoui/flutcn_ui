import 'package:flutter/material.dart';

/// Avatar sizes following shadcn UI patterns
/// Defines the predefined sizes for the [FlutAvatar] widget.
enum AvatarSize {
  /// A small avatar size.
  sm, // Small
  /// A medium avatar size. This is often the default.
  md, // Medium
  /// A large avatar size.
  lg, // Large
  /// An extra large avatar size.
  xl, // Extra Large
  /// Allows for a custom size to be specified via the [customSize] property.
  custom, // Custom size
}

/// A customizable avatar widget that displays a user's profile picture or a fallback.
///
/// The [FlutAvatar] widget supports various sizes, shapes, and customization options
/// for its appearance, including background color, text color, and border.
class FlutAvatar extends StatelessWidget {
  /// The URL of the avatar image to display. If null, [fallbackText] or [child] will be used.
  final String? imageUrl;

  /// The text to display when no image is provided. Typically the user's initials.
  final String? fallbackText;

  /// The predefined size of the avatar. Defaults to [AvatarSize.md].
  final AvatarSize size;

  /// A custom size for the avatar. This is used only when [size] is set to [AvatarSize.custom].
  final double? customSize;

  /// The background color of the avatar, especially visible for fallback text or if no image is loaded.
  final Color? backgroundColor;

  /// The color of the fallback text.
  final Color? textColor;

  /// The text style for the fallback text.
  final TextStyle? textStyle;

  /// The border radius for the avatar. Applied when [shape] is [BoxShape.rectangle].
  final BorderRadius? borderRadius;

  /// The shape of the avatar. Can be [BoxShape.circle] or [BoxShape.rectangle]. Defaults to [BoxShape.circle].
  final BoxShape shape;

  /// A custom child widget to display inside the avatar. If provided, it takes precedence over [imageUrl] and [fallbackText].
  final Widget? child;

  /// The width of the border around the avatar. Defaults to 0 (no border).
  final double borderWidth;

  /// The color of the border around the avatar. Defaults to [Colors.transparent].
  final Color borderColor;

  /// Creates a [FlutAvatar] widget.
  const FlutAvatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.size = AvatarSize.md,
    this.customSize,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.borderRadius,
    this.shape = BoxShape.circle,
    this.child,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeValue = _getSizeValue();
    final fallbackStyle = _getFallbackTextStyle(theme);

    // Determine the content of the avatar
    Widget avatarContent = child ??
        (imageUrl != null
            ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: sizeValue,
                  height: sizeValue,
                  fit: BoxFit.cover,
                ),
              )
            : _buildFallback(fallbackStyle));

    // Apply shape and border
    return Container(
      width: sizeValue,
      height: sizeValue,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primary,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? borderRadius ?? BorderRadius.circular(8)
            : null,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor,
                width: borderWidth,
              )
            : null,
      ),
      child: Center(child: avatarContent),
    );
  }

  /// Builds the fallback widget, typically displaying the first letter of [fallbackText].
  ///
  /// Returns a [SizedBox.shrink()] if [fallbackText] is null.
  Widget _buildFallback(TextStyle fallbackStyle) {
    if (fallbackText == null) return const SizedBox.shrink();
    return Text(
      fallbackText!.substring(0, 1).toUpperCase(),
      style: fallbackStyle,
    );
  }

  /// Determines the numerical size (width and height) of the avatar based on the [size] property.
  ///
  /// If [size] is [AvatarSize.custom], it uses [customSize] or defaults to 32.
  double _getSizeValue() {
    switch (size) {
      case AvatarSize.sm:
        return 24;
      case AvatarSize.md:
        return 32;
      case AvatarSize.lg:
        return 40;
      case AvatarSize.xl:
        return 48;
      case AvatarSize.custom:
        return customSize ?? 32;
    }
  }

  /// Generates the [TextStyle] for the fallback text.
  ///
  /// Uses [textStyle] if provided, otherwise creates a default style based on the avatar's size and theme.
  TextStyle _getFallbackTextStyle(ThemeData theme) {
    return textStyle ??
        TextStyle(
          fontSize: _getSizeValue() * 0.5,
          fontWeight: FontWeight.bold,
          color: textColor ?? theme.colorScheme.onPrimary,
        );
  }
} 


/// A collection of factory constructors for creating [FlutAvatar] widgets with predefined sizes and common configurations.
///
/// This class provides a convenient way to create avatars without needing to specify
/// the [AvatarSize] enum directly for common sizes.
class Avatar {
  /// Creates a small [FlutAvatar] widget.
  ///
  /// The avatar will have a fixed size suitable for small contexts.
  static Widget sm({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
    Widget? child,
  }) {
    return FlutAvatar(
      imageUrl: imageUrl,
      fallbackText: fallbackText,
      size: AvatarSize.sm,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderWidth: borderWidth,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Creates a medium [FlutAvatar] widget.
  ///
  /// This is the default size for avatars.
  static Widget md({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
    Widget? child,
  }) {
    return FlutAvatar(
      imageUrl: imageUrl,
      fallbackText: fallbackText,
      size: AvatarSize.md,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderWidth: borderWidth,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Creates a large [FlutAvatar] widget.
  static Widget lg({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
    Widget? child,
  }) {
    return FlutAvatar(
      imageUrl: imageUrl,
      fallbackText: fallbackText,
      size: AvatarSize.lg,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderWidth: borderWidth,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Creates an extra large [FlutAvatar] widget.
  static Widget xl({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
    Widget? child,
  }) {
    return FlutAvatar(
      imageUrl: imageUrl,
      fallbackText: fallbackText,
      size: AvatarSize.xl,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderWidth: borderWidth,
      borderColor: borderColor,
      child: child,
    );
  }

  /// Creates a custom-sized [FlutAvatar] widget.
  ///
  /// Allows specifying an arbitrary [size] for the avatar.
  static Widget custom({
    String? imageUrl,
    String? fallbackText,
    required double size,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
    Widget? child,
  }) {
    return FlutAvatar(
      imageUrl: imageUrl,
      fallbackText: fallbackText,
      size: AvatarSize.custom,
      customSize: size,
      backgroundColor: backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      borderRadius: borderRadius,
      shape: shape,
      borderWidth: borderWidth,
      borderColor: borderColor,
      child: child,
    );
  }
}