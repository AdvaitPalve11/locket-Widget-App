# 🔥 Firebase Setup Guide for Locket Widget App

## ✅ **COMPLETED STEPS**
- Firebase CLI installed ✅
- FlutterFire CLI installed ✅
- Firebase project created: **locket-widget-app-2025** ✅
- Logged in to Firebase: advaitdpalve@gmail.com ✅
- Android app registered ✅
- google-services.json downloaded ✅

## 📋 **PROJECT INFO**
- **Project ID**: locket-widget-app-2025
- **Project Number**: 983305279615
- **Firebase Console**: https://console.firebase.google.com/project/locket-widget-app-2025/overview

## 🎯 **NEXT STEPS**

### 1. Enable Firebase Services (5 minutes)

Go to [Firebase Console](https://console.firebase.google.com/project/locket-widget-app-2025/overview) and enable:

#### 🔐 Authentication
1. Authentication → Get Started
2. Sign-in method → Enable **Email/Password**
3. Enable **Anonymous** (optional for guest users)

#### 🗄️ Cloud Firestore
1. Firestore Database → Create database
2. Start in **test mode**
3. Location: **us-central1**

#### 📦 Cloud Storage
1. Storage → Get started
2. Start in **test mode**
3. Same location as Firestore

### 2. Create firebase_options.dart (Manual)

Since FlutterFire had issues, create this file manually:

#### 🔐 Authentication
1. In Firebase Console → Authentication
2. Click "Get Started"
3. Sign-in method tab
4. Enable:
   - ✅ Email/Password
   - ✅ Google (optional but recommended)
   - ✅ Anonymous (for guest users)

#### 🗄️ Cloud Firestore
1. Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose location: **us-central1** (or closest to users)

#### 📦 Cloud Storage
1. Firebase Console → Storage
2. Click "Get started"
3. Start in **test mode**
4. Choose same location as Firestore

#### 🔔 Cloud Messaging (Optional)
1. Firebase Console → Cloud Messaging
2. No additional setup needed for basic functionality

### Step 6: Update Security Rules

#### Firestore Rules (Basic)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Photos - users can read/write their own and friends'
    match /photos/{photoId} {
      allow read, write: if request.auth != null;
    }
    
    // Friends - users can manage their friend relationships
    match /friends/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Storage Rules (Basic)
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /photos/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
  }
}
```

## ⚙️ Configuration Files

After running `flutterfire configure`, you should have:

### ✅ Generated Files
- `lib/firebase_options.dart` - Firebase configuration
- `android/app/google-services.json` - Android config
- `ios/Runner/GoogleService-Info.plist` - iOS config (if iOS selected)
- `web/firebase-config.js` - Web config (if web selected)

### 📱 Android Additional Setup
Add to `android/app/build.gradle`:
```gradle
// Already in your template, but verify:
dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    // ... other Firebase services
}
```

## 🔄 Initialize Firebase in App

Update `lib/main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## 🧪 Test Firebase Connection

Create a simple test:
```dart
// In your app, test Firebase connection
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Test authentication
FirebaseAuth.instance.authStateChanges().listen((User? user) {
  print('User signed in: ${user?.email ?? 'None'}');
});

// Test Firestore
FirebaseFirestore.instance.collection('test').add({
  'message': 'Hello Firebase!',
  'timestamp': FieldValue.serverTimestamp(),
});
```

## 🔍 Verification Steps

1. **Check Firebase Console**: See if your app appears in project settings
2. **Run App**: No Firebase-related errors in console
3. **Test Authentication**: Try signing up a test user
4. **Check Firestore**: See if test data appears in console
5. **Test Storage**: Try uploading a test image

## 🚨 Common Issues & Solutions

### Issue: "No Firebase App '[DEFAULT]' has been created"
**Solution**: Ensure `Firebase.initializeApp()` is called before `runApp()`

### Issue: "google-services.json not found"
**Solution**: Re-run `flutterfire configure` and ensure files are in correct locations

### Issue: "Firebase Auth not working"
**Solution**: Check if Email/Password is enabled in Firebase Console

### Issue: "Storage upload fails"
**Solution**: Update storage security rules to allow authenticated users

## 🎯 Quick Setup Commands

```bash
# Complete setup in order:
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
flutter pub get
flutter run
```

## 📊 Next Steps After Setup

1. ✅ Test basic authentication
2. ✅ Create user profiles in Firestore
3. ✅ Test photo upload to Storage
4. ✅ Implement friend system
5. ✅ Set up push notifications

---

**Ready to start?** Run the commands above and let me know if you encounter any issues!