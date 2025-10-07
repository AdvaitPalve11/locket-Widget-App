import 'package:flutter/services.dart';

class SoundEffectsHelper {
  static bool _soundEnabled = true;

  // Enable or disable sound effects
  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // Check if sound is enabled
  static bool get isSoundEnabled => _soundEnabled;

  // Play button click sound
  static void playButtonClick() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play camera shutter sound
  static void playCameraShutter() {
    if (_soundEnabled) {
      // Using system camera sound for now
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play notification sound
  static void playNotification() {
    if (_soundEnabled) {
      // You would typically use a package like audioplayers here
      // For now, using system alert sound
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Play success sound
  static void playSuccess() {
    if (_soundEnabled) {
      // Light, pleasant sound for success actions
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play error sound
  static void playError() {
    if (_soundEnabled) {
      // Alert sound for errors
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Play swipe sound
  static void playSwipe() {
    if (_soundEnabled) {
      // Subtle sound for swipe gestures
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play pop sound
  static void playPop() {
    if (_soundEnabled) {
      // Quick pop sound for appearing elements
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play whoosh sound
  static void playWhoosh() {
    if (_soundEnabled) {
      // Whoosh sound for transitions
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play typing sound
  static void playTyping() {
    if (_soundEnabled) {
      // Subtle typing feedback
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play unlock sound
  static void playUnlock() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play lock sound
  static void playLock() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play refresh sound
  static void playRefresh() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play delete sound
  static void playDelete() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Play send sound
  static void playSend() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play receive sound
  static void playReceive() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  // Play toggle sound
  static void playToggle() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play focus sound
  static void playFocus() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Play navigation sound
  static void playNavigation() {
    if (_soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Combined haptic and sound feedback
  static void playButtonFeedback() {
    if (_soundEnabled) {
      playButtonClick();
    }
    HapticFeedback.lightImpact();
  }

  // Combined feedback for camera capture
  static void playCameraFeedback() {
    if (_soundEnabled) {
      playCameraShutter();
    }
    HapticFeedback.heavyImpact();
  }

  // Combined feedback for success actions
  static void playSuccessFeedback() {
    if (_soundEnabled) {
      playSuccess();
    }
    HapticFeedback.lightImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
  }

  // Combined feedback for error actions
  static void playErrorFeedback() {
    if (_soundEnabled) {
      playError();
    }
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.mediumImpact();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.heavyImpact();
    });
  }

  // Combined feedback for navigation
  static void playNavigationFeedback() {
    if (_soundEnabled) {
      playNavigation();
    }
    HapticFeedback.selectionClick();
  }

  // Combined feedback for toggle actions
  static void playToggleFeedback() {
    if (_soundEnabled) {
      playToggle();
    }
    HapticFeedback.mediumImpact();
  }

  // Play contextual sound based on action type
  static void playContextualSound(SoundType type) {
    switch (type) {
      case SoundType.buttonClick:
        playButtonClick();
        break;
      case SoundType.cameraShutter:
        playCameraShutter();
        break;
      case SoundType.notification:
        playNotification();
        break;
      case SoundType.success:
        playSuccess();
        break;
      case SoundType.error:
        playError();
        break;
      case SoundType.swipe:
        playSwipe();
        break;
      case SoundType.pop:
        playPop();
        break;
      case SoundType.whoosh:
        playWhoosh();
        break;
      case SoundType.typing:
        playTyping();
        break;
      case SoundType.send:
        playSend();
        break;
      case SoundType.receive:
        playReceive();
        break;
      case SoundType.delete:
        playDelete();
        break;
      case SoundType.refresh:
        playRefresh();
        break;
      case SoundType.navigation:
        playNavigation();
        break;
    }
  }
}

// Sound type enumeration
enum SoundType {
  buttonClick,
  cameraShutter,
  notification,
  success,
  error,
  swipe,
  pop,
  whoosh,
  typing,
  send,
  receive,
  delete,
  refresh,
  navigation,
}