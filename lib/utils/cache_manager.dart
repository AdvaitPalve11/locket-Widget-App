import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';

class CacheManager {
  static const String _cacheDir = 'image_cache';
  static const int _maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const Duration _cacheExpiration = Duration(days: 7);

  static Future<Directory> get _cacheDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/$_cacheDir');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<File?> getCachedFile(String url) async {
    try {
      final cacheDir = await _cacheDirectory;
      final fileName = _generateFileName(url);
      final file = File('${cacheDir.path}/$fileName');

      if (await file.exists()) {
        final stat = await file.stat();
        final age = DateTime.now().difference(stat.modified);
        
        if (age < _cacheExpiration) {
          return file;
        } else {
          // File is expired, delete it
          await file.delete();
        }
      }
      return null;
    } catch (e) {
      print('Error getting cached file: $e');
      return null;
    }
  }

  static Future<File?> cacheFile(String url, List<int> bytes) async {
    try {
      await _cleanupCache();
      
      final cacheDir = await _cacheDirectory;
      final fileName = _generateFileName(url);
      final file = File('${cacheDir.path}/$fileName');

      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error caching file: $e');
      return null;
    }
  }

  static Future<File?> downloadAndCache(String url) async {
    try {
      // Check if already cached
      final cachedFile = await getCachedFile(url);
      if (cachedFile != null) {
        return cachedFile;
      }

      // Download the file
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: AppConstants.networkTimeoutSeconds),
      );

      if (response.statusCode == 200) {
        return await cacheFile(url, response.bodyBytes);
      }
      return null;
    } catch (e) {
      print('Error downloading and caching file: $e');
      return null;
    }
  }

  static Future<void> clearCache() async {
    try {
      final cacheDir = await _cacheDirectory;
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  static Future<int> getCacheSize() async {
    try {
      final cacheDir = await _cacheDirectory;
      int totalSize = 0;
      
      if (await cacheDir.exists()) {
        await for (final entity in cacheDir.list(recursive: true)) {
          if (entity is File) {
            final stat = await entity.stat();
            totalSize += stat.size;
          }
        }
      }
      return totalSize;
    } catch (e) {
      print('Error calculating cache size: $e');
      return 0;
    }
  }

  static Future<void> _cleanupCache() async {
    try {
      final cacheSize = await getCacheSize();
      
      if (cacheSize > _maxCacheSize) {
        final cacheDir = await _cacheDirectory;
        final files = <File>[];
        
        await for (final entity in cacheDir.list()) {
          if (entity is File) {
            files.add(entity);
          }
        }

        // Sort by last modified (oldest first)
        files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));

        // Delete oldest files until we're under the size limit
        int currentSize = cacheSize;
        for (final file in files) {
          if (currentSize <= _maxCacheSize * 0.8) break; // Keep some buffer
          
          final stat = await file.stat();
          currentSize -= stat.size;
          await file.delete();
        }
      }
    } catch (e) {
      print('Error cleaning up cache: $e');
    }
  }

  static String _generateFileName(String url) {
    return url.hashCode.abs().toString();
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}