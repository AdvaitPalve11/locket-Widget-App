import 'package:flutter/services.dart';

class HapticFeedbackHelper {
  // Light haptic feedback for subtle interactions
  static void light() {
    HapticFeedback.lightImpact();
  }

  // Medium haptic feedback for standard interactions
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  // Heavy haptic feedback for important interactions
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  // Selection feedback for picker interactions
  static void selection() {
    HapticFeedback.selectionClick();
  }

  // Success feedback pattern
  static void success() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
  }

  // Error feedback pattern
  static void error() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.heavyImpact();
    });
  }

  // Button press feedback
  static void buttonPress() {
    HapticFeedback.mediumImpact();
  }

  // Long press feedback
  static void longPress() {
    HapticFeedback.heavyImpact();
  }

  // Camera capture feedback
  static void cameraCapture() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 50), () {
      HapticFeedback.lightImpact();
    });
  }

  // Navigation feedback
  static void navigation() {
    HapticFeedback.selectionClick();
  }

  // Toggle switch feedback
  static void toggle() {
    HapticFeedback.mediumImpact();
  }

  // Delete action feedback
  static void delete() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 150), () {
      HapticFeedback.lightImpact();
    });
  }

  // Refresh feedback
  static void refresh() {
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
  }

  // Custom pattern feedback
  static void customPattern(List<int> pattern) {
    for (int i = 0; i < pattern.length; i++) {
      Future.delayed(Duration(milliseconds: pattern[i]), () {
        if (i % 2 == 0) {
          HapticFeedback.lightImpact();
        } else {
          HapticFeedback.mediumImpact();
        }
      });
    }
  }
}