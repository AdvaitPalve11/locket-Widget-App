import 'package:flutter/foundation.dart';

/// Production-ready logging system for Locket Widget App
/// Replaces debug print statements with proper logging
class AppLogger {
  static const String _tag = 'LocketApp';
  
  /// Log informational messages
  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] INFO: $message');
    }
  }
  
  /// Log error messages
  static void error(String message, [dynamic error, StackTrace? stackTrace, String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] ERROR: $message');
      if (error != null) print('Error details: $error');
      if (stackTrace != null) print('Stack trace: $stackTrace');
    }
  }
  
  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] DEBUG: $message');
    }
  }
  
  /// Log warning messages
  static void warning(String message, [String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] WARNING: $message');
    }
  }
  
  /// Log network requests
  static void network(String message, [String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] NETWORK: $message');
    }
  }
  
  /// Log authentication events
  static void auth(String message, [String? tag]) {
    if (kDebugMode) {
      print('[$_tag${tag != null ? ':$tag' : ''}] AUTH: $message');
    }
  }
}