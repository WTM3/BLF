#!/bin/bash

# Boolean Language Framework - App Launcher
# The narrow bridge between terminal and GUI

echo "🚀 Starting the V-8 engine under the hood..."
echo "Building Boolean Language Framework iMessage Bot..."

# Build the app
swift build --product BLFiMessageBot

if [ $? -eq 0 ]; then
    echo "✅ Build successful - The engine purrs with precision"
    echo "🎯 Launching BLF iMessage Bot GUI..."
    
    # Launch the app detached from terminal for proper keyboard handling
    nohup ./.build/arm64-apple-macosx/debug/BLFiMessageBot > /dev/null 2>&1 &
    echo "🎯 App launched! Check your dock or use Cmd+Tab to find the BLF window"
else
    echo "❌ Build failed - Engine light is on"
    echo "Please check the error messages above"
    exit 1
fi 