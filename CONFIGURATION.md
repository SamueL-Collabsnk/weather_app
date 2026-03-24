# Android Configuration Checklist

## ✅ Required Changes for Android

### 1. AndroidManifest.xml

Location: `android/app/src/main/AndroidManifest.xml`

Add these permissions inside `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 2. build.gradle.kts (App Level)

Location: `android/app/build.gradle.kts`

Ensure these settings:

```kotlin
android {
    compileSdk = 34  // Or latest

    defaultConfig {
        applicationId = "com.example.weathapp"
        minSdk = 21  // At least 21 for Geolocator
        targetSdk = 34  // Or latest
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}
```

### 3. Gradle Properties

Location: `android/gradle.properties`

Ensure these are set:

```properties
org.gradle.jvmargs=-Xmx4096m
android.useAndroidX=true
android.enableJetifier=true
```

### ✅ Runtime Permission Setup

The app uses `permission_handler` for runtime permissions. On first launch, users will be prompted to allow:

- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION

No additional code needed - handled automatically by the packages.

---

# iOS Configuration Checklist

## ✅ Required Changes for iOS

### 1. Info.plist Configuration

Location: `ios/Runner/Info.plist`

Add these keys inside the `<dict>` tag:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to display accurate weather information for your area.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs your location to display accurate weather information for your area.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs your location to display accurate weather information for your area.</string>
```

**Important**: These descriptions appear in the permission popup - make them user-friendly!

### 2. Podfile Configuration

Location: `ios/Podfile`

Ensure your deployment target is at least iOS 12.0:

```ruby
platform :ios, '12.0'
```

### 3. Runner.xcodeproj Settings (Optional)

Location: `ios/Runner.xcodeproj`

In Xcode, verify:

- Target: Runner
- Build Settings → Minimum Deployment Target: 12.0 or higher
- Build Settings → Search Paths → Framework Search Paths: Remove duplicates

### ✅ Building for iOS

```bash
# Clean build
flutter clean

# Get packages
flutter pub get

# Build
flutter build ios

# Or run directly
flutter run -d iphone
```

### ⚠️ Common iOS Issues

**Issue**: CocoaPods pod install fails

```bash
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
```

**Issue**: Xcode build fails

```bash
cd ios
pod repo update
pod install --repo-update
cd ..
```

---

# Web Configuration (Optional)

The app works on web too! Just run:

```bash
flutter run -d chrome
```

**Note**: Web version won't have GPS location (browser limitation), but search works fine.

---

# Testing the Setup

## After Configuration:

1. **Clean & Rebuild**

   ```bash
   flutter clean
   flutter pub get
   flutter pub get  # Run twice to ensure
   ```

2. **Run Analysis**

   ```bash
   flutter analyze
   ```

3. **Test on Device**

   ```bash
   flutter run
   ```

4. **Expected Behavior**
   - App launches
   - Requests location permission
   - Automatically fetches weather for current location
   - Shows current weather, hourly, and daily forecasts
   - All animations and UI working smoothly

---

# API Key Setup

## .env File

Location: Root of project (`weathapp/.env`)

```env
OPENWEATHER_API_KEY=your_key_here
```

### Getting a Free API Key:

1. Go to https://openweathermap.org/api
2. Sign up for free
3. Create an API key in your dashboard
4. Copy and paste into .env file
5. Restart the app

### Checking Key Works:

```bash
# Replace YOUR_KEY
curl "https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_KEY&units=metric"
```

---

# Permissions Summary

| Permission             | Purpose              | Android | iOS |
| ---------------------- | -------------------- | ------- | --- |
| ACCESS_FINE_LOCATION   | Precise GPS location | ✅      | ✅  |
| ACCESS_COARSE_LOCATION | Approximate location | ✅      | ✅  |
| INTERNET               | API calls            | ✅      | ✅  |

---

# Installation Troubleshooting

## Dart/Flutter Issues

```bash
# Update Flutter
flutter upgrade

# Check Flutter setup
flutter doctor

# Fix issues
flutter doctor --android-licenses

# Clear cache
flutter clean
rm -rf pubspec.lock
flutter pub get
```

## Dependencies Issues

```bash
# Force upgrade
flutter pub upgrade --major-versions

# Or specific package
flutter pub add geolocator@latest
```

## Build Issues

```bash
# For Android
cd android
./gradlew clean
cd ..

# For iOS
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..

flutter run
```

---

✅ **Checklist Complete!** Your app is ready to run with full GPS and forecast features.
