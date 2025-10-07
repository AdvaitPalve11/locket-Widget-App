import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';

class NetworkHelper {
  static const Duration _timeout = Duration(seconds: AppConstants.networkTimeoutSeconds);

  static Future<Uint8List?> downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(_timeout);
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw HttpException('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(_timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<T?> withRetry<T>(
    Future<T> Function() operation, {
    int maxAttempts = AppConstants.retryAttempts,
    Duration delay = const Duration(seconds: 1),
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future.delayed(delay * attempt);
      }
    }
    return null;
  }

  static Map<String, String> getCommonHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}