import 'package:example/themes/app_palette.dart';
import 'package:flutter/material.dart';
// Helper class for button colors
class ButtonColors {
  final Color background;
  final Color foreground;

  ButtonColors({required this.background, required this.foreground});
}

/// Button variants following shadcn UI button patterns
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  link,
  destructive,
  custom, // New variant for fully customized buttons
}

/// Button sizes following shadcn UI button patterns
enum ButtonSize {
  sm,
  md,
  lg,
  icon,
  custom, // New size for fully customized dimensions
}

class FlutButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool iconOnly;
  final Widget? child;

  // New customization parameters
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? hoverBackgroundColor;
  final Color? pressedBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? loadingIndicatorColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final double? hoverElevation;
  final double? pressedElevation;
  final double? disabledElevation;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final BoxShape? shape;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double? loadingSize;
  final Color? overlayColor;
  final double? minWidth;
  final double? minHeight;
  final MainAxisAlignment? contentAlignment;
  final TextStyle? textStyle;

  const FlutButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.isLoading = false,
    this.isDisabled = false,
    this.iconOnly = false,
    this.child,
    // New customization parameters
    this.backgroundColor,
    this.foregroundColor,
    this.hoverBackgroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.loadingIndicatorColor,
    this.borderColor,
    this.borderWidth,
    this.elevation,
    this.hoverElevation,
    this.pressedElevation,
    this.disabledElevation,
    this.borderRadius,
    this.width,
    this.height,
    this.fontSize,
    this.iconSize,
    this.fontWeight,
    this.padding,
    this.animationDuration,
    this.animationCurve,
    this.shape,
    this.gradient,
    this.boxShadow,
    this.loadingSize,
    this.overlayColor,
    this.minWidth,
    this.minHeight,
    this.contentAlignment,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final colors = _getColorsForVariant(theme);
    final isEnabled = onPressed != null && !isDisabled && !isLoading;

    // Compute size-related properties (applicable to all variants)
    final buttonPadding = padding ?? _getPadding();
    final buttonFontSize = fontSize ?? _getFontSize(theme);
    final buttonHeight = height ?? _getHeight();
    final buttonWidth = width;
    final buttonIconSize = iconSize ?? _getIconSize();
    final buttonLoadingSize = loadingSize ?? buttonIconSize;
    final buttonMinWidth = minWidth ?? (iconOnly ? buttonHeight : 64);
    final buttonMinHeight = minHeight ?? buttonHeight;
    final buttonFontWeight = fontWeight ?? FontWeight.w600;
    final buttonContentAlignment = contentAlignment ?? MainAxisAlignment.center;
    final buttonAnimationDuration =
        animationDuration ?? const Duration(milliseconds: 200);
    final buttonAnimationCurve = animationCurve ?? Curves.easeInOut;

    // Base button style from theme based on variant
    ButtonStyle baseStyle;
    if (variant == ButtonVariant.custom) {
      baseStyle = ElevatedButton.styleFrom();
    } else if (variant == ButtonVariant.outline) {
      baseStyle = theme.outlinedButtonTheme.style ?? OutlinedButton.styleFrom();
    } else if (variant == ButtonVariant.ghost ||
        variant == ButtonVariant.link) {
      baseStyle = theme.textButtonTheme.style ?? TextButton.styleFrom();
    } else {
      baseStyle = theme.elevatedButtonTheme.style ?? ElevatedButton.styleFrom();
    }

    // Define button style with conditional customizations
    final ButtonStyle buttonStyle = baseStyle.copyWith(
      // Colors: Only use custom colors for custom variant
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (variant == ButtonVariant.custom) {
          final baseColor = backgroundColor ?? colors.background;
          if (!isEnabled)
            return disabledBackgroundColor ?? baseColor.withOpacity(0.5);
          if (states.contains(WidgetState.pressed))
            return pressedBackgroundColor ?? baseColor.withOpacity(0.9);
          if (states.contains(WidgetState.hovered))
            return hoverBackgroundColor ?? baseColor.withOpacity(0.8);
          return baseColor;
        } else {
          final baseColor = colors.background;
          if (!isEnabled) return baseColor.withOpacity(0.5);
          if (states.contains(WidgetState.pressed))
            return baseColor.withOpacity(0.9);
          if (states.contains(WidgetState.hovered))
            return baseColor.withOpacity(0.8);
          return baseColor;
        }
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (variant == ButtonVariant.custom) {
          final baseColor = foregroundColor ?? colors.foreground;
          if (!isEnabled)
            return disabledForegroundColor ?? baseColor.withOpacity(0.5);
          return baseColor;
        } else {
          final baseColor = colors.foreground;
          if (!isEnabled) return baseColor.withOpacity(0.5);
          return baseColor;
        }
      }),
      overlayColor: WidgetStateProperty.all(
        variant == ButtonVariant.custom
            ? (overlayColor ?? Colors.transparent)
            : Colors.transparent,
      ),
      shadowColor: WidgetStateProperty.all(theme.shadowColor),
      // Elevation: Only use custom elevation for custom variant
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (variant == ButtonVariant.custom) {
          if (!isEnabled) return disabledElevation ?? 0;
          if (states.contains(WidgetState.pressed))
            return pressedElevation ?? elevation ?? 0;
          if (states.contains(WidgetState.hovered))
            return hoverElevation ?? elevation ?? 0;
          return elevation ?? 0;
        }
        return 0; // Default from theme for non-custom variants
      }),
      // Shape and border: Only use custom values for custom variant
      shape: WidgetStateProperty.all(
        variant == ButtonVariant.custom && shape != null
            ? (shape == BoxShape.circle
                ? CircleBorder(
                    side: borderWidth != null && borderColor != null
                        ? BorderSide(
                            color: isEnabled
                                ? borderColor!
                                : borderColor!.withOpacity(0.5),
                            width: borderWidth!,
                          )
                        : BorderSide.none,
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        borderRadius ?? _getBorderRadiusValue(theme)),
                    side: borderWidth != null && borderColor != null
                        ? BorderSide(
                            color: isEnabled
                                ? borderColor!
                                : borderColor!.withOpacity(0.5),
                            width: borderWidth!,
                          )
                        : BorderSide.none,
                  ))
            : (variant == ButtonVariant.outline
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_getBorderRadiusValue(theme)),
                    side: BorderSide(
                      color: isEnabled
                          ? colors.foreground
                          : colors.foreground.withOpacity(0.5),
                      width: 1.0,
                    ),
                  )
                : RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_getBorderRadiusValue(theme)),
                    side: BorderSide
                        .none, // No border for ghost and other variants
                  )),
      ),
      // Size-related properties (applied to all variants)
      padding: WidgetStateProperty.all(buttonPadding),
      textStyle: WidgetStateProperty.all(
        textStyle ??
            TextStyle(
              fontSize: buttonFontSize,
              fontWeight: buttonFontWeight,
            ),
      ),
      minimumSize:
          WidgetStateProperty.all(Size(buttonMinWidth, buttonMinHeight)),
      maximumSize: buttonWidth != null
          ? WidgetStateProperty.all(Size(buttonWidth, double.infinity))
          : null,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: buttonAnimationDuration,
      enableFeedback: true,
    );

    // Build button content
    Widget buttonContent = _buildButtonContent(
      variant == ButtonVariant.custom
          ? (foregroundColor ?? colors.foreground)
          : colors.foreground,
      buttonFontSize,
      buttonIconSize,
      buttonContentAlignment,
      buttonFontWeight,
      buttonLoadingSize,
      variant == ButtonVariant.custom
          ? (loadingIndicatorColor ?? colors.foreground)
          : colors.foreground,
    );

    // Apply gradient and box shadow only for custom variant
    if (variant == ButtonVariant.custom &&
        (gradient != null || boxShadow != null)) {
      buttonContent = Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: shape != BoxShape.circle
              ? BorderRadius.circular(
                  borderRadius ?? _getBorderRadiusValue(theme))
              : null,
          shape:
              shape == BoxShape.circle ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: boxShadow,
        ),
        child: buttonContent,
      );
    }

    // Choose the right button type based on variant
    if (variant == ButtonVariant.link) {
      return TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle.copyWith(
          textStyle: WidgetStateProperty.all(TextStyle(
            decoration: TextDecoration.underline,
          )),
        ),
        child: buttonContent,
      );
    } else if (variant == ButtonVariant.outline) {
      return OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    } else if (variant == ButtonVariant.ghost) {
      return TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle.copyWith(
          // Ensure no border for ghost variant
          side: WidgetStateProperty.all(BorderSide.none),
        ),
        child: buttonContent,
      );
    } else {
      return ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: buttonStyle,
        child: buttonContent,
      );
    }
  }

  // Helper method to build button content with enhanced customization
  Widget _buildButtonContent(
    Color foregroundColor,
    double fontSize,
    double iconSize,
    MainAxisAlignment alignment,
    FontWeight fontWeight,
    double loadingSize,
    Color loadingColor,
  ) {
    if (isLoading) {
      return SizedBox(
        width: loadingSize,
        height: loadingSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    if (iconOnly && icon != null) {
      return Icon(icon, size: iconSize);
    }

    // Text with optional icon
    List<Widget> rowChildren = [];

    if (icon != null) {
      rowChildren.add(Icon(icon, size: iconSize));
      if (text != null) {
        rowChildren.add(const SizedBox(width: 8));
      }
    }

    if (text != null) {
      rowChildren.add(
        Text(
          text!,
          style: textStyle ??
              TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: rowChildren,
    );
  }

  // Get colors based on button variant
  ButtonColors _getColorsForVariant(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final colors = AppPalette.colors;

    switch (variant) {
      case ButtonVariant.primary:
        return ButtonColors(
          background:
              isDark ? colors['primaryForeground']! : colors['primary']!,
          foreground:
              isDark ? colors['primary']! : colors['primaryForeground']!,
        );
      case ButtonVariant.secondary:
        return ButtonColors(
          background: isDark ? colors['darkMuted']! : colors['secondary']!,
          foreground: isDark
              ? colors['darkForeground']!
              : colors['secondaryForeground']!,
        );
      case ButtonVariant.outline:
        return ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? colors['darkForeground']! : colors['primary']!,
        );
      case ButtonVariant.ghost:
        return ButtonColors(
          background: Colors.transparent, // Transparent background
          foreground: isDark ? colors['darkForeground']! : colors['primary']!,
        );
      case ButtonVariant.link:
        return ButtonColors(
          background: Colors.transparent,
          foreground: isDark ? colors['darkForeground']! : colors['primary']!,
        );
      case ButtonVariant.destructive:
        return ButtonColors(
          background: colors['destructive']!,
          foreground: colors['destructiveForeground']!,
        );
      case ButtonVariant.custom:
        return ButtonColors(
          background: backgroundColor ??
              (isDark ? colors['primaryForeground']! : colors['primary']!),
          foreground: foregroundColor ??
              (isDark ? colors['primary']! : colors['primaryForeground']!),
        );
    }
  }

  // Get padding based on button size and icon-only state
  EdgeInsets _getPadding() {
    if (iconOnly) {
      return EdgeInsets.zero;
    }

    switch (size) {
      case ButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case ButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ButtonSize.icon:
        return const EdgeInsets.all(10);
      case ButtonSize.custom:
        // For custom size, we'll use the provided padding
        // or fall back to medium padding
        return (padding as EdgeInsets?) ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    }
  }

  // Get border radius value from theme
  double _getBorderRadiusValue(ThemeData theme) {
    const double radiusDefault = 8.0;
    return radiusDefault;
  }

  // Get font size based on button size
  double _getFontSize(ThemeData theme) {
    switch (size) {
      case ButtonSize.sm:
        return 14;
      case ButtonSize.md:
        return 16;
      case ButtonSize.lg:
        return 18;
      case ButtonSize.icon:
        return 16;
      case ButtonSize.custom:
        // For custom size, we'll use the provided font size
        // or fall back to medium font size
        return fontSize ?? 16;
    }
  }

  // Get height based on button size
  double _getHeight() {
    switch (size) {
      case ButtonSize.sm:
        return 32;
      case ButtonSize.md:
        return 40;
      case ButtonSize.lg:
        return 48;
      case ButtonSize.icon:
        return 40;
      case ButtonSize.custom:
        // For custom size, we'll use the provided height
        // or fall back to medium height
        return height ?? 40;
    }
  }

  // Get icon size based on button size
  double _getIconSize() {
    switch (size) {
      case ButtonSize.sm:
        return 16;
      case ButtonSize.md:
        return 18;
      case ButtonSize.lg:
        return 20;
      case ButtonSize.icon:
        return 20;
      case ButtonSize.custom:
        // For custom size, we'll use the provided icon size
        // or fall back to medium icon size
        return iconSize ?? 18;
    }
  }
}

// Factory methods for easier button creation with enhanced customization
class Button {
  // Primary button
  static Widget primary({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Secondary button
  static Widget secondary({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Outline button
  static Widget outline({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Ghost button
  static Widget ghost({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // Customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.ghost,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Link button
  static Widget link({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.link,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Destructive button
  static Widget destructive({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.destructive,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // Icon button
  static Widget icon({
    required IconData icon,
    VoidCallback? onPressed,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.icon,
    bool isLoading = false,
    bool isDisabled = false,
    // New customization parameters
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
  }) {
    return FlutButton(
      icon: icon,
      onPressed: onPressed,
      variant: variant,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      iconOnly: true,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      iconSize: iconSize,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
    );
  }

  // New custom button
  static Widget custom({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    Widget? child,
    bool isLoading = false,
    bool isDisabled = false,
    bool iconOnly = false,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    Duration? animationDuration,
    Curve? animationCurve,
    BoxShape? shape,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    Color? overlayColor,
    double? minWidth,
    double? minHeight,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.custom,
      size: ButtonSize.custom,
      isLoading: isLoading,
      isDisabled: isDisabled,
      iconOnly: iconOnly,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      shape: shape,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      overlayColor: overlayColor,
      minWidth: minWidth,
      minHeight: minHeight,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // New gradient button
  static Widget gradient({
    String? text,
    IconData? icon,
    VoidCallback? onPressed,
    required Gradient gradient,
    ButtonSize size = ButtonSize.md,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? borderRadius,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    FontWeight? fontWeight,
    EdgeInsetsGeometry? padding,
    List<BoxShadow>? boxShadow,
    double? loadingSize,
    MainAxisAlignment? contentAlignment,
    TextStyle? textStyle,
  }) {
    return FlutButton(
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: ButtonVariant.custom,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      backgroundColor: Colors.transparent, // Transparent for gradient to show
      foregroundColor: foregroundColor ?? Colors.white,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      borderRadius: borderRadius,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      fontWeight: fontWeight,
      padding: padding,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize,
      contentAlignment: contentAlignment,
      textStyle: textStyle,
      child: child,
    );
  }

  // New circular button
  static Widget circular({
    IconData? icon,
    VoidCallback? onPressed,
    double size = 50,
    ButtonVariant variant = ButtonVariant.primary,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? child,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverBackgroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? loadingIndicatorColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    double? hoverElevation,
    double? pressedElevation,
    double? disabledElevation,
    Gradient? gradient,
    List<BoxShadow>? boxShadow,
    double? iconSize,
    double? loadingSize,
    Color? overlayColor,
  }) {
    return FlutButton(
      icon: icon,
      onPressed: onPressed,
      variant: variant,
      size: ButtonSize.custom,
      isLoading: isLoading,
      isDisabled: isDisabled,
      iconOnly: true,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      hoverBackgroundColor: hoverBackgroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      loadingIndicatorColor: loadingIndicatorColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: elevation,
      hoverElevation: hoverElevation,
      pressedElevation: pressedElevation,
      disabledElevation: disabledElevation,
      width: size,
      height: size,
      iconSize: iconSize ?? size / 2,
      padding: EdgeInsets.zero,
      shape: BoxShape.circle,
      gradient: gradient,
      boxShadow: boxShadow,
      loadingSize: loadingSize ?? size / 2.5,
      overlayColor: overlayColor,
      minWidth: size,
      minHeight: size,
      child: child,
    );
  }
}
