# Locket Widget App - Release Configuration

This document outlines the steps to prepare your Locket Widget app for release on both iOS App Store and Google Play Store.

## 📱 App Information
- **App Name**: Locket Widget
- **Package Name**: com.locket.widget.app
- **Current Version**: 1.0.0+1
- **Minimum SDK**: 
  - iOS: 12.0
  - Android: API 21 (Android 5.0)

## 🎨 App Icons & Splash Screen

### Creating App Icons
1. Create a 1024x1024 PNG image for your app icon
2. Save it as `assets/icons/app_icon.png`
3. Run: `flutter pub run flutter_launcher_icons`

### Creating Splash Screen
1. Create a 512x512 PNG image for splash screen
2. Save it as `assets/icons/splash_icon.png`
3. Run: `flutter pub run flutter_native_splash:create`

## 🔧 Android Release Setup

### 1. Generate Signing Key
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Create `android/key.properties`
```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<location-of-the-key-store-file>
```

### 3. Update `android/app/build.gradle`
Add signing configuration and update buildTypes.

### 4. Update App Information
Edit `android/app/src/main/AndroidManifest.xml`:
- Update app name
- Add required permissions
- Configure activities

### 5. Build Release APK/AAB
```bash
flutter build appbundle --release
# or
flutter build apk --release
```

## 🍎 iOS Release Setup

### 1. Open Xcode Project
```bash
open ios/Runner.xcworkspace
```

### 2. Configure App Settings
- Set Bundle Identifier
- Configure signing certificates
- Update Info.plist with privacy descriptions
- Set deployment target to iOS 12.0

### 3. Archive and Upload
1. Product → Archive
2. Upload to App Store Connect
3. Submit for review

## 📝 Store Listings

### App Store Connect (iOS)
- App name: Locket Widget
- Subtitle: Share moments instantly
- Description: Modern widget-based photo sharing app
- Keywords: widget, photos, sharing, friends, moments
- Category: Social Networking

### Google Play Console (Android)
- App name: Locket Widget
- Short description: Modern photo sharing through widgets
- Full description: Complete app description with features
- Category: Social
- Content rating: Teen (13+)

## 🔒 Privacy & Permissions

### Required Permissions
- Camera access for photo capture
- Photo library access
- Network access for sharing
- Notification permissions
- Location access (optional)

### Privacy Policy
Create and host a privacy policy covering:
- Data collection practices
- Photo storage and sharing
- Third-party services (Firebase)
- User rights and controls

## 🚀 Release Checklist

### Pre-Release
- [ ] Update version number in pubspec.yaml
- [ ] Test on physical devices
- [ ] Run `flutter analyze` and fix all issues
- [ ] Run `flutter test` and ensure all tests pass
- [ ] Create app icons and splash screens
- [ ] Update README.md with app information
- [ ] Create privacy policy
- [ ] Test release builds

### Android Release
- [ ] Generate signing key
- [ ] Configure build.gradle
- [ ] Build signed AAB
- [ ] Test release build
- [ ] Upload to Google Play Console
- [ ] Complete store listing
- [ ] Submit for review

### iOS Release
- [ ] Configure Xcode project
- [ ] Set up signing certificates
- [ ] Archive and validate
- [ ] Upload to App Store Connect
- [ ] Complete store listing
- [ ] Submit for review

## 📊 Analytics & Monitoring

Consider adding:
- Firebase Analytics
- Crashlytics for crash reporting
- Performance monitoring
- User feedback systems

## 🔄 Post-Release

### Updates
- Monitor crash reports
- Gather user feedback
- Plan feature updates
- Maintain compatibility with OS updates

### Marketing
- Social media promotion
- User community building
- App Store Optimization (ASO)
- User acquisition campaigns

---

For more detailed information, refer to:
- [Flutter deployment documentation](https://docs.flutter.dev/deployment)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Policy Center](https://play.google.com/about/developer-content-policy/)