import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'error_handler.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      ErrorHandler.showSnackBar(
        context,
        'Camera permission is required to take photos and videos.',
        isError: true,
      );
      return false;
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Camera Permission Required',
        'Camera access is needed to take photos and videos. Please enable it in app settings.',
      );
      return false;
    }
    return false;
  }

  static Future<bool> requestStoragePermission(BuildContext context) async {
    final status = await Permission.storage.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      ErrorHandler.showSnackBar(
        context,
        'Storage permission is required to save photos and videos.',
        isError: true,
      );
      return false;
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Storage Permission Required',
        'Storage access is needed to save photos and videos. Please enable it in app settings.',
      );
      return false;
    }
    return false;
  }

  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    final status = await Permission.microphone.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      ErrorHandler.showSnackBar(
        context,
        'Microphone permission is required to record videos with audio.',
        isError: true,
      );
      return false;
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Microphone Permission Required',
        'Microphone access is needed to record videos with audio. Please enable it in app settings.',
      );
      return false;
    }
    return false;
  }

  static Future<bool> requestPhotosPermission(BuildContext context) async {
    final status = await Permission.photos.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      ErrorHandler.showSnackBar(
        context,
        'Photos permission is required to access your photo library.',
        isError: true,
      );
      return false;
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Photos Permission Required',
        'Photos access is needed to select images from your library. Please enable it in app settings.',
      );
      return false;
    }
    return false;
  }

  static Future<bool> checkAllMediaPermissions(BuildContext context) async {
    final cameraGranted = await requestCameraPermission(context);
    final storageGranted = await requestStoragePermission(context);
    final microphoneGranted = await requestMicrophonePermission(context);
    final photosGranted = await requestPhotosPermission(context);

    return cameraGranted && storageGranted && microphoneGranted && photosGranted;
  }

  static void _showPermissionDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}