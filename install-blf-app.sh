#!/bin/bash

# Boolean Language Framework - App Installer
# Creates a proper macOS app bundle for system integration

echo "🚀 Building and installing the V-8 engine as a proper macOS app..."

# Build the executable
echo "📦 Building executable..."
swift build --product BLFiMessageBot

if [ $? -ne 0 ]; then
    echo "❌ Build failed - Engine light is on"
    exit 1
fi

# App bundle details
APP_NAME="BLF iMessage Bot"
APP_BUNDLE="BLF iMessage Bot.app"
BUNDLE_ID="com.blf.imessagebot"
VERSION="1.0.0"

# Clean and create app bundle structure
echo "🏗️  Creating app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy executable
echo "⚡ Installing V-8 engine..."
cp "./.build/arm64-apple-macosx/debug/BLFiMessageBot" "$APP_BUNDLE/Contents/MacOS/BLFiMessageBot"

# Create Info.plist
echo "📋 Creating app metadata..."
cat > "$APP_BUNDLE/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>BLFiMessageBot</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>BLFM</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.productivity</string>
    <key>NSHumanReadableCopyright</key>
    <string>Boolean Language Framework - The V-8 Under the Hood</string>
</dict>
</plist>
EOF

# Make executable
chmod +x "$APP_BUNDLE/Contents/MacOS/BLFiMessageBot"

echo "✅ App bundle created successfully!"
echo "🎯 Installing to Applications folder..."

# Install to Applications
if [ -d "/Applications/$APP_BUNDLE" ]; then
    echo "🔄 Removing existing installation..."
    rm -rf "/Applications/$APP_BUNDLE"
fi

cp -R "$APP_BUNDLE" "/Applications/"

if [ $? -eq 0 ]; then
    echo "✅ Installation complete!"
    echo "🚀 The V-8 engine is now installed as a proper macOS app"
    echo "📱 Find '$APP_NAME' in your Applications folder or Launchpad"
    echo "⌨️  Keyboard input should now work perfectly!"
    echo ""
    echo "🎯 Opening the app now..."
    open "/Applications/$APP_BUNDLE"
else
    echo "❌ Installation failed - couldn't copy to Applications"
    echo "🎯 You can run it locally with:"
    echo "   open '$APP_BUNDLE'"
fi 