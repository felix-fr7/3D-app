# 📱 Flutter Mobile App Setup & Permissions Guide

Follow these simple configuration steps to ensure the camera and networking function properly on Android and iOS devices.

---

## 1. Android Configuration

### `android/app/src/main/AndroidManifest.xml`
Ensure the following permissions are present inside the `<manifest>` tag (before `<application>`):

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Camera & Storage Permissions -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <application
        android:label="Facts Vision"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true"> <!-- Required for local http:// backend connection -->
        
        <!-- ... existing activity tags ... -->
    </application>
</manifest>
```

> **Note**: `android:usesCleartextTraffic="true"` allows Android to connect to your local HTTP Node.js server (`http://10.0.2.2:5000` or `http://192.168.x.x:5000`) without SSL restriction during development.

---

## 2. iOS Configuration

### `ios/Runner/Info.plist`
Add the following keys inside `<dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to recognize landmarks and cultural monuments.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires photo library access to upload photos for landmark discovery.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Required if recording video landmarks.</string>
```

---

## 3. Configuring Backend IP (`mobile/lib/services/api_service.dart`)

Inside `mobile/lib/services/api_service.dart`, update the `baseUrl` according to your test environment:

```dart
// 1. Android Emulator:
static const String baseUrl = 'http://10.0.2.2:5000/api';

// 2. iOS Simulator:
// static const String baseUrl = 'http://127.0.0.1:5000/api';

// 3. Physical Android/iOS Device connected to same Wi-Fi:
// static const String baseUrl = 'http://192.168.1.15:5000/api';
```

