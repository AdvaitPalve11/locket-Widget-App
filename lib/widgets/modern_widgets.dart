import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../utils/visual_effects.dart';
import '../utils/animation_helpers.dart';

class ModernWidgets {
  // Modern gradient button with enhanced design
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
    double width = double.infinity,
    double height = 50,
    bool isLoading = false,
    IconData? icon,
    Color? startColor,
    Color? endColor,
  }) {
    return AnimationHelpers.scaleTransition(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              startColor ?? AppColors.primaryPurple,
              endColor ?? AppColors.lightPurple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          boxShadow: VisualEffects.modernShadow(
            color: startColor ?? AppColors.primaryPurple,
            opacity: 0.3,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            onTap: isLoading ? null : onPressed,
            child: Container(
              alignment: Alignment.center,
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: AppTextStyles.subtitle1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern glass card effect with enhanced blur
  static Widget glassCard({
    required Widget child,
    double blur = 15,
    double opacity = 0.12,
    Color? color,
    EdgeInsets? padding,
    VoidCallback? onTap,
  }) {
    return VisualEffects.glassmorphism(
      blur: blur,
      opacity: opacity,
      color: color ?? Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
            child: child,
          ),
        ),
      ),
    );
  }

  // Enhanced modern FAB with multiple styles
  static Widget modernFAB({
    required VoidCallback onPressed,
    required IconData icon,
    String? heroTag,
    FABStyle style = FABStyle.gradient,
    Color? backgroundColor,
    double size = 56,
  }) {
    Widget fabContent = Icon(
      icon,
      color: Colors.white,
      size: size * 0.5,
    );

    switch (style) {
      case FABStyle.gradient:
        return VisualEffects.modernFloatingActionButton(
          onPressed: onPressed,
          backgroundColor: backgroundColor,
          heroTag: heroTag,
          child: fabContent,
        );
      case FABStyle.glass:
        return SizedBox(
          width: size,
          height: size,
          child: VisualEffects.glassmorphism(
            child: FloatingActionButton(
              heroTag: heroTag,
              onPressed: onPressed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: fabContent,
            ),
          ),
        );
      case FABStyle.neumorphism:
        return VisualEffects.neumorphismCard(
          child: FloatingActionButton(
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              icon,
              color: AppColors.primaryPurple,
              size: size * 0.5,
            ),
          ),
        );
    }
  }

  // Enhanced modern app bar with customization
  static PreferredSizeWidget modernAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    AppBarStyle style = AppBarStyle.gradient,
    Color? backgroundColor,
    double elevation = 0,
  }) {
    final appBar = AppBar(
      title: Text(
        title,
        style: AppTextStyles.headline2.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      elevation: elevation,
      backgroundColor: style == AppBarStyle.solid 
          ? (backgroundColor ?? AppColors.primaryPurple)
          : Colors.transparent,
      flexibleSpace: style == AppBarStyle.gradient
          ? Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.darkPurple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          : style == AppBarStyle.glass
              ? VisualEffects.glassmorphism(
                  color: AppColors.primaryPurple,
                  opacity: 0.8,
                  borderRadius: BorderRadius.zero,
                  child: Container(),
                )
              : null,
    );

    return appBar;
  }

  // Enhanced hover card with multiple interaction states
  static Widget interactiveCard({
    required Widget child,
    required VoidCallback onTap,
    double elevation = 3,
    Color? color,
    EdgeInsets? padding,
    bool enableHover = true,
    InteractionStyle style = InteractionStyle.elevation,
  }) {
    return AnimationHelpers.scaleTransition(
      child: VisualEffects.modernCard(
        color: color,
        elevation: elevation,
        padding: padding,
        onTap: onTap,
        child: child,
      ),
    );
  }

  // Enhanced modern text field with validation states
  static Widget modernTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? hintText,
    bool enabled = true,
    FocusNode? focusNode,
    void Function(String)? onChanged,
    TextFieldStyle style = TextFieldStyle.modern,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        boxShadow: style == TextFieldStyle.elevated
            ? VisualEffects.modernShadow(
                blurRadius: 8,
                offset: const Offset(0, 4),
                opacity: 0.1,
              )
            : null,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        enabled: enabled,
        focusNode: focusNode,
        onChanged: onChanged,
        style: AppTextStyles.body1.copyWith(
          color: enabled ? AppColors.black : AppColors.grey,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: AppTextStyles.body1.copyWith(color: AppColors.grey),
          hintStyle: AppTextStyles.body1.copyWith(color: AppColors.lightGrey),
          prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, color: AppColors.primaryPurple, size: 20)
              : null,
          suffixIcon: suffixIcon != null 
              ? IconButton(
                  icon: Icon(suffixIcon, color: AppColors.primaryPurple, size: 20),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          filled: true,
          fillColor: style == TextFieldStyle.glass
              ? Colors.white.withOpacity(0.1)
              : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            borderSide: style == TextFieldStyle.outlined
                ? const BorderSide(color: AppColors.lightGrey)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            borderSide: style == TextFieldStyle.outlined
                ? const BorderSide(color: AppColors.lightGrey)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            borderSide: const BorderSide(color: AppColors.primaryPurple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.defaultPadding,
          ),
        ),
      ),
    );
  }

  // Enhanced bottom sheet with drag handle
  static void showModernBottomSheet({
    required BuildContext context,
    required Widget child,
    double? height,
    bool isScrollControlled = true,
    bool showDragHandle = true,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height ?? MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.largePadding),
          ),
          boxShadow: VisualEffects.modernShadow(
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ),
        child: Column(
          children: [
            if (showDragHandle)
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  // Enhanced snackbar with action button
  static void showModernSnackBar({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SnackBarType.warning:
        backgroundColor = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.info;
        icon = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body1.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onActionPressed,
            )
          : null,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Loading overlay with modern design
  static Widget loadingOverlay({
    required bool isLoading,
    required Widget child,
    String? loadingText,
    Color? overlayColor,
  }) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: (overlayColor ?? Colors.black).withOpacity(0.5),
            child: Center(
              child: VisualEffects.glassmorphism(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                      ),
                      if (loadingText != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          loadingText,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Enums for different styles
enum FABStyle { gradient, glass, neumorphism }
enum AppBarStyle { gradient, glass, solid }
enum InteractionStyle { elevation, scale, glow }
enum TextFieldStyle { modern, glass, outlined, elevated }
enum SnackBarType { success, error, warning, info }
