#!/bin/bash

# Weather App - Quick Run Script
# This script helps you run the weather app on your Android phone

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         🌤️ WEATHER APP - RUN ON ANDROID PHONE 🌤️            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if device is connected
echo "🔍 Checking for connected devices..."
devices=$(adb devices -l | grep -v "List of devices" | grep -v "^$")

if [ -z "$devices" ]; then
    echo "❌ No devices found!"
    echo ""
    echo "Please:"
    echo "  1. Connect your phone via USB"
    echo "  2. Enable Developer Mode (tap Build Number 7 times)"
    echo "  3. Enable USB Debugging in Developer options"
    echo "  4. Approve the 'Allow USB debugging?' prompt on your phone"
    echo ""
    exit 1
fi

echo "✅ Device(s) found:"
echo "$devices"
echo ""

# Check if device is authorized
if echo "$devices" | grep -q "unauthorized"; then
    echo "⚠️  Device is UNAUTHORIZED!"
    echo ""
    echo "Your phone is showing a permission request."
    echo ""
    echo "Please:"
    echo "  1. Look at your phone screen"
    echo "  2. Check for 'Allow USB debugging?' popup"
    echo "  3. Tap 'Allow' (check 'Always allow' for convenience)"
    echo "  4. Wait 5 seconds"
    echo "  5. Run this script again"
    echo ""
    exit 1
fi

if echo "$devices" | grep -q "device$"; then
    echo "✅ Device is AUTHORIZED!"
    echo ""
    echo "🚀 Installing and running Weather App..."
    echo ""
    
    cd /home/samuel/Desktop/flutter_projects/weather_app/weathapp
    
    echo "📦 Building app..."
    flutter run
    
    exit 0
else
    echo "⚠️  Device status unclear"
    echo ""
    echo "Run: adb devices -l"
    echo "And check the device status"
    exit 1
fi
