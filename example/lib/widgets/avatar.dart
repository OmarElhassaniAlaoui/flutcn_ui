import 'package:flutter/material.dart';

/// Avatar sizes following shadcn UI patterns
enum AvatarSize {
  sm, // Small
  md, // Medium
  lg, // Large
  xl, // Extra Large
  custom, // Custom size
}

class FlutAvatar extends StatelessWidget {
  final String? imageUrl; // URL of the avatar image
  final String? fallbackText; // Fallback text if no image is provided
  final AvatarSize size; // Size of the avatar
  final double? customSize; // Custom size (used if size is AvatarSize.custom)
  final Color? backgroundColor; // Background color for fallback
  final Color? textColor; // Text color for fallback
  final TextStyle? textStyle; // Custom text style for fallback
  final BorderRadius? borderRadius; // Border radius for the avatar
  final BoxShape shape; // Shape of the avatar (circle or rectangle)
  final Widget? child; // Custom child widget
  final double borderWidth; // Border width
  final Color borderColor; // Border color

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

  /// Build fallback text if no image is provided
  Widget _buildFallback(TextStyle fallbackStyle) {
    if (fallbackText == null) return const SizedBox.shrink();
    return Text(
      fallbackText!.substring(0, 1).toUpperCase(),
      style: fallbackStyle,
    );
  }

  /// Get the size value based on the selected size
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

  /// Get the fallback text style
  TextStyle _getFallbackTextStyle(ThemeData theme) {
    return textStyle ??
        TextStyle(
          fontSize: _getSizeValue() * 0.5,
          fontWeight: FontWeight.bold,
          color: textColor ?? theme.colorScheme.onPrimary,
        );
  }
} 


class Avatar {
  /// Small avatar
  static Widget sm({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    Widget? child,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
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
      child: child,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  /// Medium avatar
  static Widget md({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    Widget? child,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
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
      child: child,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  /// Large avatar
  static Widget lg({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    Widget? child,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
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
      child: child,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  /// Extra large avatar
  static Widget xl({
    String? imageUrl,
    String? fallbackText,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    Widget? child,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
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
      child: child,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }

  /// Custom-sized avatar
  static Widget custom({
    String? imageUrl,
    String? fallbackText,
    required double size,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.circle,
    Widget? child,
    double borderWidth = 0,
    Color borderColor = Colors.transparent,
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
      child: child,
      borderWidth: borderWidth,
      borderColor: borderColor,
    );
  }
}