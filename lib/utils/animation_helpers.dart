import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class AnimationHelpers {
  // Smooth fade transition
  static Widget fadeTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    bool animate = true,
  }) {
    return AnimatedOpacity(
      opacity: animate ? 1.0 : 0.0,
      duration: duration,
      child: child,
    );
  }

  // Smooth slide transition
  static Widget slideTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
    bool animate = true,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: animate ? begin : end, end: end),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(offset.dx * 100, offset.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }

  // Smooth scale transition
  static Widget scaleTransition({
    required Widget child,
    Duration duration = const Duration(milliseconds: 350),
    double begin = 0.8,
    double end = 1.0,
    bool animate = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: animate ? begin : end, end: end),
      duration: duration,
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: child,
    );
  }

  // Staggered list animation
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Page transition builder
  static Widget pageTransition({
    required Widget child,
    required Animation<double> animation,
    SlideDirection direction = SlideDirection.right,
  }) {
    Offset begin;
    switch (direction) {
      case SlideDirection.up:
        begin = const Offset(0, 1);
        break;
      case SlideDirection.down:
        begin = const Offset(0, -1);
        break;
      case SlideDirection.left:
        begin = const Offset(1, 0);
        break;
      case SlideDirection.right:
        begin = const Offset(-1, 0);
        break;
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Shimmer animation for loading states
  static Widget shimmerEffect({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor ?? Colors.grey[300]!,
                highlightColor ?? Colors.grey[100]!,
                baseColor ?? Colors.grey[300]!,
              ],
              stops: [
                (value - 1).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 1).clamp(0.0, 1.0),
              ],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // Bouncy button animation
  static Widget bouncyButton({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: duration,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTapDown: (_) {
              // Trigger scale down animation
            },
            onTapUp: (_) {
              onPressed();
              // Trigger scale up animation
            },
            onTapCancel: () {
              // Reset scale
            },
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  // Rotating loading animation
  static Widget rotatingLoader({
    double size = 24,
    Color? color,
    Duration duration = const Duration(seconds: 1),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159, // Full rotation
          child: child,
        );
      },
      child: Icon(
        Icons.refresh,
        size: size,
        color: color ?? AppColors.primaryPurple,
      ),
    );
  }

  // Modern progress indicator
  static Widget modernProgressIndicator({
    double? value,
    Color? backgroundColor,
    Color? valueColor,
    double height = 6,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        color: backgroundColor ?? AppColors.lightGrey,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}

enum SlideDirection { up, down, left, right }

// Custom page route with modern transitions
class ModernPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;

  ModernPageRoute({
    required this.child,
    this.direction = SlideDirection.right,
  }) : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, _) => child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return AnimationHelpers.pageTransition(
      child: child,
      animation: animation,
      direction: direction,
    );
  }
}