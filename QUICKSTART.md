# ⚡ Quick Start Guide

## 🚀 Get Running in 5 Minutes

### Step 1: Install Dependencies (1 minute)

```bash
cd /home/samuel/Desktop/flutter_projects/weather_app/weathapp
flutter pub get
```

### Step 2: Setup API Key (2 minutes)

```bash
# Open or create .env file in project root
nano .env
```

Add this line:

```env
OPENWEATHER_API_KEY=your_api_key_here
```

Get free API key: https://openweathermap.org/api

### Step 3: Run the App (2 minutes)

```bash
# On Android phone
flutter run

# On iOS phone
flutter run -d iphone

# On Web (no GPS though)
flutter run -d chrome
```

### Step 4: Grant Permission

When app launches, **allow location permission** when prompted.

✅ **Done!** The app should now show weather for your current location.

---

## 📋 What to See

### On First Launch:

1. ⟳ Loading indicator
2. Location permission prompt → Tap **Allow**
3. ⟳ Fetching weather...
4. ✅ Current weather card
5. 📊 Hourly and daily forecasts
6. 🔄 Auto-refresh starts

---

## 🔧 If Something Goes Wrong

### Error: "API key not found"

```
Solution: Make sure .env file exists in project root with:
OPENWEATHER_API_KEY=your_actual_key
```

### Error: "Location permissions are denied"

```
Solution:
Android: Settings → Apps → Weather App → Permissions → Allow Location
iOS: Settings → Privacy → Location → Weather App → Allow
```

### Error: "City not found"

```
Solution: Use search for a larger city name (e.g., "London" not "Small Town")
```

### Black screen or crash

```
Solution: Run these commands:
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Key Features to Try

### 1. Search for Different City

- Tap search bar
- Type "Paris", "New York", "Tokyo", etc.
- Press Enter or tap search button
- ✅ Weather updates instantly

### 2. See Forecasts

- Scroll down to see hourly forecast
- Continue scrolling for 5-day forecast
- Notice rain chance and humidity percentages

### 3. Toggle Dark/Light Mode

- Tap moon/sun icon in top right
- ✅ Everything changes color automatically

### 4. Manual Refresh

- Tap refresh icon in header
- Or pull down the screen
- ✅ Weather updates fresh

### 5. View Details

- Look at the weather card
- See: Feels Like, Humidity, Wind, Pressure, Visibility, Sunrise/Sunset

---

## 📂 Project Structure (Quick Overview)

```
lib/
├── main.dart                          ← App starts here
├── screens/weather_screen.dart        ← Main UI
├── services/weather_service.dart      ← API calls & GPS
├── models/
│   ├── weather_model.dart            ← Data classes
│   ├── weather_provider.dart          ← State management
│   └── theme.dart                     ← Dark/light mode
└── widgets/                           ← Reusable components
    ├── weather_info_card.dart
    ├── hourly_forecast.dart
    ├── daily_forecast.dart
    └── search_city.dart
```

---

## 🔍 Testing Checklist

After running, verify:

- [ ] App shows weather for current location
- [ ] Temperature displayed correctly
- [ ] Hourly forecast shows 24 items
- [ ] Daily forecast shows 5 items
- [ ] Search works (try "London")
- [ ] Dark mode toggle works
- [ ] Refresh button works
- [ ] No error messages in console

---

## 📞 Quick Troubleshooting

| Problem          | Solution                              |
| ---------------- | ------------------------------------- |
| Won't run        | `flutter clean && flutter pub get`    |
| No location data | Grant permission in device settings   |
| Black screen     | Check console with `flutter logs`     |
| API errors       | Verify API key in .env file           |
| Forecast missing | Wait 5 seconds, network might be slow |
| UI looks broken  | Check theme setting, try toggling     |

---

## 🎨 UI Overview

### Top Section

```
Good Afternoon! 🕑    🔄 🌙
```

- Greeting changes throughout day
- Refresh button (manual update)
- Theme toggle button

### Search Bar

```
[🔍 Search city...]  [🔎]
```

- Type city name
- Tap search or press Enter

### Current Weather Card

```
┌─────────────────────┐
│ London          23° │
│ Clear               │
├─────────────────────┤
│ 6 weather details   │
│ (Humidity, Wind, etc)
└─────────────────────┘
```

### Hourly Forecast

```
Scrollable →
[16:00] [17:00] [18:00] ...
 23°    22°     20°    ...
```

### Daily Forecast

```
Fri, Mar 24  25° 20°  ☀️
Sat, Mar 25  22° 18°  ☁️
Sun, Mar 26  19° 15°  🌧️
...
```

---

## 💡 Tips

1. **First Run**: Location takes 2-5 seconds, be patient
2. **Accuracy**: GPS works best with clear sky
3. **Searches**: Larger city names work best
4. **Refresh**: Auto-updates every 10 minutes
5. **Offline**: Search won't work without internet
6. **Battery**: GPS only used once per app start

---

## 🌍 Supported Features

✅ Current weather
✅ GPS location detection
✅ Hourly forecasts (24 hours)
✅ Daily forecasts (5 days)
✅ City search
✅ Dark/Light mode
✅ Auto-refresh
✅ Pull-to-refresh
✅ Beautiful animations
✅ Full error handling

---

## 📚 Detailed Docs

For more information, see:

- `UPGRADE_GUIDE.md` - Full feature list
- `CONFIGURATION.md` - Android/iOS setup
- `ARCHITECTURE.md` - Technical details
- `EXAMPLES.md` - Expected outputs
- `CHANGELOG.md` - What changed

---

## 🆘 Still Having Issues?

1. Check `flutter logs` output
2. Verify API key is correct
3. Ensure location permissions granted
4. Check internet connection
5. Try `flutter clean` and rebuild
6. Check device location services enabled

---

## ✅ You're All Set!

Everything is configured and ready to go. Just run:

```bash
flutter run
```

And enjoy your modern weather app! 🌤️

---

**Need help?** Check the documentation files or review the console logs with `flutter logs`.

**Happy weather tracking!** 🎉
