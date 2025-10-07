import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void handleFirebaseAuthError(BuildContext context, String errorCode) {
    String message;
    switch (errorCode) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;
      case 'weak-password':
        message = 'Password is too weak. Please choose a stronger password.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your internet connection.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      default:
        message = 'An error occurred. Please try again.';
    }
    showSnackBar(context, message, isError: true);
  }

  static void handleNetworkError(BuildContext context) {
    showSnackBar(
      context, 
      'Network error. Please check your internet connection.', 
      isError: true
    );
  }

  static void handleStorageError(BuildContext context) {
    showSnackBar(
      context, 
      'Storage error. Please check your device storage.', 
      isError: true
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.toString().contains('permission')) {
      return 'Permission denied. Please check app permissions.';
    } else if (error.toString().contains('storage')) {
      return 'Storage error. Please check your device storage.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}