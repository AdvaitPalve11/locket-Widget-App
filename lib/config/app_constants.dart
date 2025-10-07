import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Locket Widget';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Share ephemeral photos and videos with friends';

  // Media Configuration
  static const int maxVideoLengthSeconds = 30;
  static const int maxPhotoSizeMB = 10;
  static const int maxVideoSizeMB = 50;
  static const int photoQuality = 80;
  static const int videoQuality = 80;

  // Expiration Settings
  static const int mediaExpirationHours = 24;
  static const int cleanupIntervalMinutes = 30;

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 8.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Network Configuration
  static const int networkTimeoutSeconds = 30;
  static const int retryAttempts = 3;

  // Storage Paths
  static const String localPhotosPath = 'Locket_Downloads';
  static const String tempMediaPath = 'temp_media';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String photosCollection = 'photos';
  static const String friendsCollection = 'friends';
  static const String notificationsCollection = 'notifications';

  // Notification Types
  static const String newPhotoNotification = 'new_photo';
  static const String newVideoNotification = 'new_video';
  static const String friendRequestNotification = 'friend_request';
  static const String friendAcceptedNotification = 'friend_accepted';
}

class AppColors {
  // Primary Colors
  static const primaryPurple = Color(0xFF6C5CE7);
  static const darkPurple = Color(0xFF5A4FCF);
  static const lightPurple = Color(0xFF8B7ED8);

  // Neutral Colors
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFF9E9E9E);
  static const lightGrey = Color(0xFFF5F5F5);
  static const darkGrey = Color(0xFF424242);

  // Status Colors
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFF44336);
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF2196F3);

  // Dark Mode Colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkOnSurface = Color(0xFFE0E0E0);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const body1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}