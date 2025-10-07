import 'package:flutter/material.dart';
import '../utils/haptic_feedback_helper.dart';
import '../utils/sound_effects_helper.dart';

class GestureHandler extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final Function(ScaleUpdateDetails)? onPinch;
  final VoidCallback? onPinchStart;
  final VoidCallback? onPinchEnd;
  final bool enableHapticFeedback;
  final bool enableSoundFeedback;
  final Duration longPressDuration;
  final double swipeThreshold;

  const GestureHandler({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onPinch,
    this.onPinchStart,
    this.onPinchEnd,
    this.enableHapticFeedback = true,
    this.enableSoundFeedback = true,
    this.longPressDuration = const Duration(milliseconds: 500),
    this.swipeThreshold = 50.0,
  });

  @override
  State<GestureHandler> createState() => _GestureHandlerState();
}

class _GestureHandlerState extends State<GestureHandler> {
  Offset? _panStartOffset;
  bool _isPinching = false;

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedbackHelper.light();
    }
    if (widget.enableSoundFeedback) {
      SoundEffectsHelper.playButtonClick();
    }
    widget.onTap?.call();
  }

  void _handleDoubleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedbackHelper.medium();
    }
    if (widget.enableSoundFeedback) {
      SoundEffectsHelper.playPop();
    }
    widget.onDoubleTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableHapticFeedback) {
      HapticFeedbackHelper.heavy();
    }
    if (widget.enableSoundFeedback) {
      SoundEffectsHelper.playButtonClick();
    }
    widget.onLongPress?.call();
  }

  void _handlePanStart(DragStartDetails details) {
    _panStartOffset = details.localPosition;
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_panStartOffset == null || _isPinching) return;

    final velocity = details.velocity.pixelsPerSecond;
    final distance = velocity.distance;

    if (distance > widget.swipeThreshold) {
      final direction = velocity.direction;
      
      if (widget.enableHapticFeedback) {
        HapticFeedbackHelper.light();
      }
      if (widget.enableSoundFeedback) {
        SoundEffectsHelper.playSwipe();
      }

      // Determine swipe direction
      if (direction >= -0.785 && direction <= 0.785) {
        // Right swipe
        widget.onSwipeRight?.call();
      } else if (direction >= 2.356 || direction <= -2.356) {
        // Left swipe
        widget.onSwipeLeft?.call();
      } else if (direction >= 0.785 && direction <= 2.356) {
        // Down swipe
        widget.onSwipeDown?.call();
      } else if (direction >= -2.356 && direction <= -0.785) {
        // Up swipe
        widget.onSwipeUp?.call();
      }
    }

    _panStartOffset = null;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (details.pointerCount > 1) {
      _isPinching = true;
      if (widget.enableHapticFeedback) {
        HapticFeedbackHelper.light();
      }
      widget.onPinchStart?.call();
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_isPinching && details.pointerCount > 1) {
      widget.onPinch?.call(details);
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_isPinching) {
      _isPinching = false;
      if (widget.enableHapticFeedback) {
        HapticFeedbackHelper.light();
      }
      widget.onPinchEnd?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null ? _handleTap : null,
      onDoubleTap: widget.onDoubleTap != null ? _handleDoubleTap : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      onPanStart: (widget.onSwipeLeft != null ||
                  widget.onSwipeRight != null ||
                  widget.onSwipeUp != null ||
                  widget.onSwipeDown != null)
          ? _handlePanStart
          : null,
      onPanEnd: (widget.onSwipeLeft != null ||
                widget.onSwipeRight != null ||
                widget.onSwipeUp != null ||
                widget.onSwipeDown != null)
          ? _handlePanEnd
          : null,
      onScaleStart: (widget.onPinch != null ||
                    widget.onPinchStart != null ||
                    widget.onPinchEnd != null)
          ? _handleScaleStart
          : null,
      onScaleUpdate: widget.onPinch != null ? _handleScaleUpdate : null,
      onScaleEnd: (widget.onPinch != null ||
                  widget.onPinchStart != null ||
                  widget.onPinchEnd != null)
          ? _handleScaleEnd
          : null,
      child: widget.child,
    );
  }
}

// Gesture utilities
class GestureUtils {
  // Calculate gesture velocity
  static double calculateVelocity(Offset start, Offset end, Duration duration) {
    final distance = (end - start).distance;
    final timeInSeconds = duration.inMilliseconds / 1000.0;
    return distance / timeInSeconds;
  }

  // Get gesture direction
  static GestureDirection getGestureDirection(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    if (dx.abs() > dy.abs()) {
      return dx > 0 ? GestureDirection.right : GestureDirection.left;
    } else {
      return dy > 0 ? GestureDirection.down : GestureDirection.up;
    }
  }

  // Check if gesture is a swipe
  static bool isSwipeGesture(Offset start, Offset end, double threshold) {
    return (end - start).distance > threshold;
  }

  // Get gesture angle in radians
  static double getGestureAngle(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return dx != 0 ? (dy / dx).abs() : 0;
  }

  // Check if gesture is horizontal
  static bool isHorizontalGesture(Offset start, Offset end) {
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();
    return dx > dy;
  }

  // Check if gesture is vertical
  static bool isVerticalGesture(Offset start, Offset end) {
    final dx = (end.dx - start.dx).abs();
    final dy = (end.dy - start.dy).abs();
    return dy > dx;
  }
}

// Gesture direction enumeration
enum GestureDirection {
  up,
  down,
  left,
  right,
}

// Advanced gesture detector with custom recognizers
class AdvancedGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final VoidCallback? onTapCancel;
  final Function(LongPressStartDetails)? onLongPressStart;
  final Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final Function(LongPressEndDetails)? onLongPressEnd;
  final Function(DragStartDetails)? onPanStart;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(DragEndDetails)? onPanEnd;
  final bool enableFeedback;

  const AdvancedGestureDetector({
    super.key,
    required this.child,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.enableFeedback = true,
  });

  @override
  State<AdvancedGestureDetector> createState() => _AdvancedGestureDetectorState();
}

class _AdvancedGestureDetectorState extends State<AdvancedGestureDetector> {
  void _handleTapDown(TapDownDetails details) {
    if (widget.enableFeedback) {
      HapticFeedbackHelper.light();
    }
    widget.onTapDown?.call(details);
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enableFeedback) {
      SoundEffectsHelper.playButtonClick();
    }
    widget.onTapUp?.call(details);
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    if (widget.enableFeedback) {
      HapticFeedbackHelper.heavy();
    }
    widget.onLongPressStart?.call(details);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTapDown != null ? _handleTapDown : null,
      onTapUp: widget.onTapUp != null ? _handleTapUp : null,
      onTapCancel: widget.onTapCancel,
      onLongPressStart: widget.onLongPressStart != null ? _handleLongPressStart : null,
      onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
      onLongPressEnd: widget.onLongPressEnd,
      onPanStart: widget.onPanStart,
      onPanUpdate: widget.onPanUpdate,
      onPanEnd: widget.onPanEnd,
      child: widget.child,
    );
  }
}

// Swipe gesture detector
class SwipeGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(SwipeDirection)? onSwipe;
  final double threshold;
  final bool enableFeedback;

  const SwipeGestureDetector({
    super.key,
    required this.child,
    this.onSwipe,
    this.threshold = 50.0,
    this.enableFeedback = true,
  });

  @override
  State<SwipeGestureDetector> createState() => _SwipeGestureDetectorState();
}

class _SwipeGestureDetectorState extends State<SwipeGestureDetector> {
  Offset? _startOffset;

  void _handlePanStart(DragStartDetails details) {
    _startOffset = details.localPosition;
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_startOffset == null) return;

    // For pan gestures, we need to calculate based on velocity
    final velocity = details.velocity.pixelsPerSecond;
    final distance = velocity.distance;

    if (distance > widget.threshold) {
      final direction = velocity.direction;
      
      if (widget.enableFeedback) {
        HapticFeedbackHelper.light();
        SoundEffectsHelper.playSwipe();
      }

      SwipeDirection swipeDirection;
      if (direction >= -0.785 && direction <= 0.785) {
        swipeDirection = SwipeDirection.right;
      } else if (direction >= 2.356 || direction <= -2.356) {
        swipeDirection = SwipeDirection.left;
      } else if (direction >= 0.785 && direction <= 2.356) {
        swipeDirection = SwipeDirection.down;
      } else {
        swipeDirection = SwipeDirection.up;
      }

      widget.onSwipe?.call(swipeDirection);
    }

    _startOffset = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanEnd: _handlePanEnd,
      child: widget.child,
    );
  }
}

enum SwipeDirection { up, down, left, right }