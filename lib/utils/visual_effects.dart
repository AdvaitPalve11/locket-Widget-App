import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class VisualEffects {
  // Glassmorphism effect
  static Widget glassmorphism({
    required Widget child,
    double blur = 20,
    double opacity = 0.1,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: (color ?? Colors.white).withOpacity(opacity),
          borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: Colors.white.withValues(alpha: ),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: ),
              blurRadius: blur,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  // Neumorphism card effect
  static Widget neumorphismCard({
    required Widget child,
    double depth = 4,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    final cardColor = color ?? Colors.grey[100]!;
    final radius = borderRadius ?? BorderRadius.circular(AppConstants.borderRadius);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-depth, -depth),
            blurRadius: depth * 2,
          ),
          BoxShadow(
            color: Colors.grey[300]!,
            offset: Offset(depth, depth),
            blurRadius: depth * 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // Gradient background
  static Widget gradientBackground({
    required Widget child,
    List<Color>? colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [
            AppColors.primaryPurple.withValues(alpha: ),
            AppColors.lightPurple.withValues(alpha: ),
            Colors.white,
          ],
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }

  // Floating particle background
  static Widget particleBackground({
    required Widget child,
    int particleCount = 20,
    Color particleColor = Colors.white,
  }) {
    return Stack(
      children: [
        ...List.generate(particleCount, (index) {
          return Positioned(
            left: (index * 37) % 100.0,
            top: (index * 47) % 100.0,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 2000 + (index * 100)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(
                    (value * 50) - 25,
                    (value * 30) - 15,
                  ),
                  child: Opacity(
                    opacity: (0.3 + (value * 0.4)).clamp(0.0, 0.7),
                    child: Container(
                      width: 4 + (index % 3),
                      height: 4 + (index % 3),
                      decoration: BoxDecoration(
                        color: particleColor.withValues(alpha: ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        child,
      ],
    );
  }

  // Modern shadow effect
  static List<BoxShadow> modernShadow({
    Color color = Colors.black,
    double opacity = 0.1,
    double blurRadius = 20,
    Offset offset = const Offset(0, 10),
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withOpacity(opacity * 0.5),
        blurRadius: blurRadius * 0.5,
        offset: Offset(offset.dx, offset.dy * 0.5),
        spreadRadius: 0,
      ),
    ];
  }

  // Glow effect
  static Widget glowEffect({
    required Widget child,
    Color glowColor = Colors.blue,
    double glowRadius = 20,
    double spread = 2,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: ),
            blurRadius: glowRadius,
            spreadRadius: spread,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: ),
            blurRadius: glowRadius * 2,
            spreadRadius: spread * 2,
          ),
        ],
      ),
      child: child,
    );
  }

  // Ripple effect widget
  static Widget rippleEffect({
    required Widget child,
    required VoidCallback onTap,
    Color rippleColor = Colors.white,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
        splashColor: rippleColor.withValues(alpha: ),
        highlightColor: rippleColor.withValues(alpha: ),
        onTap: onTap,
        child: child,
      ),
    );
  }

  // Floating action button with modern design
  static Widget modernFloatingActionButton({
    required VoidCallback onPressed,
    required Widget child,
    Color? backgroundColor,
    double elevation = 8,
    String? heroTag,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor ?? AppColors.primaryPurple,
            (backgroundColor ?? AppColors.primaryPurple).withValues(alpha: ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: modernShadow(
          color: backgroundColor ?? AppColors.primaryPurple,
          opacity: 0.4,
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ),
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: child,
      ),
    );
  }

  // Modern card with hover effect
  static Widget modernCard({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets? padding,
    Color? color,
    double elevation = 4,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: modernShadow(
          blurRadius: elevation * 4,
          offset: Offset(0, elevation),
        ),
      ),
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

  // Animated gradient container
  static Widget animatedGradientContainer({
    required Widget child,
    Duration duration = const Duration(seconds: 3),
    List<Color>? colors,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors ?? [
                AppColors.primaryPurple,
                AppColors.lightPurple,
                AppColors.primaryPurple,
              ],
              stops: [
                (value - 0.5).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.5).clamp(0.0, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

// Custom clipper for modern shapes
class ModernClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      0,
      size.width,
      size.height * 0.2,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
