import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityHelper {
  static const String _keyPrefix = 'locket_secure_';
  static const String _saltKey = 'app_salt';

  // Generate a secure random salt
  static String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  // Get or create app salt
  static Future<String> getAppSalt() async {
    final prefs = await SharedPreferences.getInstance();
    String? salt = prefs.getString(_saltKey);
    
    if (salt == null) {
      salt = generateSalt();
      await prefs.setString(_saltKey, salt);
    }
    
    return salt;
  }

  // Hash a password with salt
  static Future<String> hashPassword(String password) async {
    final salt = await getAppSalt();
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verify password
  static Future<bool> verifyPassword(String password, String hashedPassword) async {
    final hash = await hashPassword(password);
    return hash == hashedPassword;
  }

  // Generate secure token
  static String generateSecureToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Encode(bytes);
  }

  // Encrypt sensitive data (simple Base64 encoding for demo)
  static String encryptData(String data) {
    final bytes = utf8.encode(data);
    return base64Encode(bytes);
  }

  // Decrypt sensitive data
  static String decryptData(String encryptedData) {
    try {
      final bytes = base64Decode(encryptedData);
      return utf8.decode(bytes);
    } catch (e) {
      return '';
    }
  }

  // Store encrypted data
  static Future<void> storeSecureData(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedData = encryptData(data);
    await prefs.setString('$_keyPrefix$key', encryptedData);
  }

  // Retrieve encrypted data
  static Future<String?> getSecureData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedData = prefs.getString('$_keyPrefix$key');
    
    if (encryptedData == null) return null;
    
    return decryptData(encryptedData);
  }

  // Clear all secure data
  static Future<void> clearAllSecureData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }

  // Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate password strength
  static PasswordStrength getPasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.weak;
    
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int score = 0;
    if (hasLower) score++;
    if (hasUpper) score++;
    if (hasDigits) score++;
    if (hasSpecial) score++;
    if (password.length >= 12) score++;
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  // Generate strong password
  static String generateStrongPassword({int length = 12}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Sanitize user input
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'''[<>&"'`]'''), '') // Remove dangerous characters
        .trim();
  }

  // Validate file type
  static bool isValidImageType(String fileName) {
    final allowedTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extension = fileName.split('.').last.toLowerCase();
    return allowedTypes.contains(extension);
  }

  // Validate video file type
  static bool isValidVideoType(String fileName) {
    final allowedTypes = ['mp4', 'mov', 'avi', 'mkv', 'webm'];
    final extension = fileName.split('.').last.toLowerCase();
    return allowedTypes.contains(extension);
  }

  // Check if content contains profanity (basic implementation)
  static bool containsProfanity(String content) {
    final profanityWords = [
      // Add your profanity filter words here
      'spam', 'fake', 'scam',
    ];
    
    final lowercaseContent = content.toLowerCase();
    return profanityWords.any((word) => lowercaseContent.contains(word));
  }

  // Rate limiting check
  static bool isRateLimited(String action, {int maxAttempts = 5, Duration window = const Duration(minutes: 1)}) {
    // This would typically be implemented with a more sophisticated backend
    // For now, return false (not rate limited)
    return false;
  }

  // Generate session ID
  static String generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random.secure().nextInt(999999);
    return '${timestamp}_$random';
  }
}

// Privacy helper class
class PrivacyHelper {
  static const String _privacyPrefix = 'privacy_';

  // Privacy settings
  static Future<void> setPrivacySetting(String setting, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_privacyPrefix$setting', value);
  }

  // Get privacy setting
  static Future<bool> getPrivacySetting(String setting, {bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_privacyPrefix$setting') ?? defaultValue;
  }

  // Check if user has consented to data collection
  static Future<bool> hasDataCollectionConsent() async {
    return await getPrivacySetting('data_collection_consent', defaultValue: false);
  }

  // Set data collection consent
  static Future<void> setDataCollectionConsent(bool consent) async {
    await setPrivacySetting('data_collection_consent', consent);
  }

  // Check if analytics is enabled
  static Future<bool> isAnalyticsEnabled() async {
    return await getPrivacySetting('analytics_enabled', defaultValue: false);
  }

  // Set analytics enabled
  static Future<void> setAnalyticsEnabled(bool enabled) async {
    await setPrivacySetting('analytics_enabled', enabled);
  }

  // Check if crash reporting is enabled
  static Future<bool> isCrashReportingEnabled() async {
    return await getPrivacySetting('crash_reporting_enabled', defaultValue: true);
  }

  // Set crash reporting enabled
  static Future<void> setCrashReportingEnabled(bool enabled) async {
    await setPrivacySetting('crash_reporting_enabled', enabled);
  }

  // Anonymize user data
  static String anonymizeEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***@***.***';
    
    final username = parts[0];
    final domain = parts[1];
    
    String anonymizedUsername;
    if (username.length <= 2) {
      anonymizedUsername = '*' * username.length;
    } else {
      anonymizedUsername = username[0] + ('*' * (username.length - 2)) + username[username.length - 1];
    }
    
    return '$anonymizedUsername@$domain';
  }

  // Get privacy-compliant user identifier
  static Future<String> getPrivacyCompliantUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('privacy_user_id');
    
    if (userId == null) {
      userId = SecurityHelper.generateSecureToken();
      await prefs.setString('privacy_user_id', userId);
    }
    
    return userId;
  }

  // Clear all privacy data
  static Future<void> clearAllPrivacyData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_privacyPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}

// Enums
enum PasswordStrength {
  weak,
  medium,
  strong,
}

enum PrivacySetting {
  dataCollection,
  analytics,
  crashReporting,
  locationSharing,
  photoSharing,
}

// Data classification
enum DataSensitivity {
  public,
  internal,
  confidential,
  restricted,
}