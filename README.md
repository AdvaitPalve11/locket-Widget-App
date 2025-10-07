# 🔐 Locket Widget - Photo & Video Sharing App

A Flutter-based social media app inspired by Locket Widget, allowing users to share ephemeral photos and videos with friends. Media automatically expires after 24 hours with download functionality and Snapchat-style captions.

## ✨ Features

### 📸 Media Sharing
- **Photo Capture**: Take photos directly from the camera
- **Video Recording**: Record videos up to 30 seconds
- **Gallery Selection**: Choose existing media from device gallery
- **Ephemeral Content**: All media expires after 24 hours
- **Download Support**: Save friends' photos and videos before they expire

### 🎨 Rich Captions
- **Snapchat-style Text Editor**: Add styled captions to photos and videos
- **Multiple Fonts**: Choose from various font styles
- **Color Picker**: Customize text colors
- **Text Alignment**: Left, center, or right alignment
- **Real-time Preview**: See changes as you edit

### � Social Features
- **Friend System**: Add and manage friends
- **Feed**: View friends' shared media in a grid layout
- **Reactions**: React to friends' photos and videos
- **Expiration Timer**: See how much time is left before media expires

### 🎬 Video Features
- **Video Thumbnails**: Automatic thumbnail generation for videos
- **Full-screen Playback**: Tap videos to watch in full-screen
- **Video Controls**: Play, pause, and seek controls
- **Duration Display**: Show video length on thumbnails and player

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- Firebase account for backend services

### Dependencies
- `firebase_core` - Firebase integration
- `firebase_auth` - User authentication
- `cloud_firestore` - Database
- `firebase_storage` - File storage
- `image_picker` - Camera and gallery access
- `video_player` - Video playback
- `shared_preferences` - Local storage
- `home_widget` - Widget functionality
- `path_provider` - File system access
- `http` - Network requests

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/locket-widget-app.git
   cd locket-widget-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore Database, and Storage
   - Download `google-services.json` for Android and place it in `android/app/`
   - Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

| Home Screen | Camera Screen | Video Player |
|-------------|---------------|--------------|
| *Feed with photos and videos* | *Capture with captions* | *Full-screen video playback* |

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/          # Data models (Photo, User, Friend, etc.)
├── services/        # Business logic (PhotoService, AuthService, etc.)
├── screens/         # UI screens
│   ├── auth/        # Authentication screens
│   ├── camera/      # Camera and media capture
│   ├── friends/     # Friend management
│   ├── home/        # Main feed screen
│   ├── profile/     # User profile
│   └── settings/    # App settings
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

### Key Components

- **Photo Model**: Enhanced to support both photos and videos with rich metadata
- **PhotoService**: Handles media upload, download, and Firebase integration
- **Enhanced Camera Screen**: Comprehensive media capture with Snapchat-style features
- **Photo Grid**: Displays media feed with video support and expiration timers

## 🔧 Configuration

### Firebase Rules
Set up Firestore security rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /photos/{photoId} {
        allow read, write: if request.auth != null;
      }
      
      match /friends/{friendId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📋 Todo List

- [ ] Push notifications for new media
- [ ] Video thumbnail generation on server
- [ ] Advanced video editing features
- [ ] Group sharing functionality
- [ ] Dark mode support
- [ ] Widget implementation for home screen

## 🐛 Known Issues

- Video thumbnail generation is placeholder-based
- Gradle cache issues on some Windows setups (resolved with `flutter clean`)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by Locket Widget app
- Firebase for backend services
- Flutter team for the amazing framework
- Video player package contributors

## 📞 Contact

- **Developer**: Advait Palve
- **GitHub**: [@yourusername](https://github.com/AdvaitPalve11)

---

Built with ❤️ using Flutter & Firebase
4. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```
5. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.3.1')
}
```

#### iOS Configuration (Optional)
1. Add iOS app to Firebase project
2. Download `GoogleService-Info.plist`
3. Add it to `ios/Runner/` directory

### 3. Firebase Configuration

#### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /friendRequests/{requestId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /photos/{photoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /myPhotos/{photoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

#### Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /photos/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### 5. Home Widget Setup

For Android widget functionality, additional configuration is needed:
1. Widget provider XML
2. Widget layout
3. Widget service class
4. Manifest registration

### 6. Run the App
```bash
flutter run
```

## App Flow

### 1. Download the App
Users download and install the Locket Widget app from the app store.

### 2. Add Friends
- Create an account or sign in
- Navigate to Friends tab
- Add friends by email address
- Accept/reject friend requests

### 3. Add the Widget
- Install the Locket Widget on home screen
- Widget displays friends' latest photos
- Updates automatically when friends share new photos

### 4. Start Sharing
- Take photos using the camera button
- Add captions (optional)
- Share with all friends at once
- Photos appear on friends' widgets and in-app feed

## Technical Architecture

### Backend Services
- **Firebase Authentication**: User management
- **Cloud Firestore**: User data, friends, metadata
- **Cloud Storage**: Photo storage and CDN
- **Firebase Functions**: Background processing (optional)

### State Management
- Basic setState() for simple state
- StreamBuilder for real-time updates
- Future builders for async operations

### Key Libraries
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `firebase_storage`: File storage
- `image_picker`: Camera and gallery access
- `home_widget`: Widget integration
- `shared_preferences`: Local storage

## Development Notes

### Current Status
- ✅ Authentication system
- ✅ Friend management
- ✅ Photo sharing
- ✅ Real-time feed
- ✅ Basic UI/UX
- ⏳ Home widget integration
- ⏳ Push notifications
- ⏳ Photo compression/optimization

### Next Steps
1. Implement home widget for Android
2. Add push notifications for new photos
3. Optimize image compression and caching
4. Add photo reactions/comments
5. Implement user profiles with avatars
6. Add privacy settings
7. Performance optimizations

### Known Issues
- Home widget not yet implemented
- No offline support
- No image compression
- Basic error handling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is for educational purposes. The Locket Widget concept is inspired by the original Locket app.
