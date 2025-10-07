import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/photo.dart';

class WidgetService {
  static const String _latestPhotoKey = 'latest_photo';

  // Initialize the widget (placeholder implementation)
  static Future<void> initializeWidget() async {
    try {
      // TODO: Initialize home widget when home_widget package is properly set up
      print('Widget service initialized');
    } catch (e) {
      print('Error initializing widget: $e');
    }
  }

  // Update widget with latest photo (placeholder implementation)
  static Future<void> updateWidget(Photo? photo) async {
    try {
      if (photo != null) {
        // Save photo data to shared preferences for widget access
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_latestPhotoKey, jsonEncode(photo.toMap()));
        
        // TODO: Update actual widget when home_widget package is properly configured
        print('Widget updated with photo from ${photo.userName}');
      } else {
        // Clear widget data
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_latestPhotoKey);
        
        // TODO: Clear actual widget when home_widget package is properly configured
        print('Widget cleared');
      }
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  // Get latest photo from widget storage
  static Future<Photo?> getLatestWidgetPhoto() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photoJson = prefs.getString(_latestPhotoKey);
      
      if (photoJson != null) {
        final photoMap = jsonDecode(photoJson) as Map<String, dynamic>;
        return Photo.fromMap(photoMap, '');
      }
      
      return null;
    } catch (e) {
      print('Error getting latest widget photo: $e');
      return null;
    }
  }

  // Clear widget data
  static Future<void> clearWidget() async {
    try {
      await updateWidget(null);
    } catch (e) {
      print('Error clearing widget: $e');
    }
  }
}

/*
Widget implementation notes:

To implement the actual home widget functionality, you need to:

1. Add home_widget dependency to pubspec.yaml (already added)
2. Create Android widget layout files:
   - android/app/src/main/res/xml/locket_widget_info.xml
   - android/app/src/main/res/layout/locket_widget.xml
   - android/app/src/main/res/drawable/ (widget backgrounds, etc.)

3. Register widget in AndroidManifest.xml:
   ```xml
   <receiver android:name="HomeWidgetLaunchIntent">
       <intent-filter>
           <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
       </intent-filter>
       <meta-data android:name="android.appwidget.provider"
                  android:resource="@xml/locket_widget_info" />
   </receiver>
   ```

4. Update this service to use actual HomeWidget methods:
   - HomeWidget.setAppGroupId()
   - HomeWidget.saveWidgetData()
   - HomeWidget.updateWidget()
   - HomeWidget.registerBackgroundCallback()

5. Add widget configuration in main.dart:
   ```dart
   await WidgetService.initializeWidget();
   ```

6. Call WidgetService.updateWidget(photo) when new photos are received

The current implementation provides local storage for widget data
and can be extended to work with the actual widget when properly configured.
*/