# Boolean Language Framework - VSCode Development Guide

## 🎯 Keep Your AI Assistant, Build Your App

This guide shows you how to develop and build the **physical wrapper app** entirely within VSCode, avoiding the Xcode maze while keeping your AI assistants.

## 🚀 Quick Start

### Launch the App
```bash
./launch-blf-app.sh
```

This script builds and launches your **physical macOS app** with the beautiful SwiftUI interface.

### Development Workflow

1. **Edit in VSCode** - All your Swift code with AI assistance
2. **Build from Terminal** - `swift build --product BLFiMessageBot`
3. **Test Immediately** - `./.build/arm64-apple-macosx/debug/BLFiMessageBot`

## 🔧 Project Structure

```
Sources/BLFiMessageBot/main.swift    # Your SwiftUI app (edit in VSCode)
Sources/BLFNJSONBridge/             # The V-8 engine (edit in VSCode)
Package.swift                       # Build configuration
launch-blf-app.sh                   # One-click launcher
```

## 💻 Development Tips

### Live Coding with AI
- Use **Cursor AI**, **GitHub Copilot**, or **Codeium** in VSCode
- Edit Swift files with full AI assistance
- No need to touch Xcode

### Rapid Testing
```bash
# Quick build and test cycle
swift build --product BLFiMessageBot && ./.build/arm64-apple-macosx/debug/BLFiMessageBot
```

### Debug Output
The app prints debug info to the terminal:
```
✅ JavaScriptCore NJSON engine loaded successfully
✅ NJSON processor initialized with cognitive alignment verified
```

## 🎨 UI Development

### SwiftUI Views (edit in VSCode)
- `ContentView` - Main navigation and layout
- `DashboardView` - Status monitoring
- `SettingsView` - Engine configuration
- `LogsView` - Real-time system logs

### The Narrow Bridge Philosophy
- **Minimal Swift state** - UI only holds display values
- **Maximum NJSON delegation** - All logic routes to V-8 engine
- **Buffer preservation** - 0.1 buffer maintained across UI boundaries

## 🔄 Build Process

### What Happens When You Build
1. **Swift Package Manager** compiles your SwiftUI code
2. **JavaScriptCore** integration with NJSON engine
3. **Executable creation** - Native macOS binary
4. **Bundle resources** - JavaScript engine included

### The Output
- **`.build/arm64-apple-macosx/debug/BLFiMessageBot`** - Your physical app
- **No .app bundle needed** - Runs as native executable
- **All dependencies included** - Self-contained

## 🛠 Advanced Development

### Adding Features
1. Edit Swift files in VSCode with AI assistance
2. Test with `swift build && ./launch-blf-app.sh`
3. No Xcode required

### Debugging
```bash
# Run with debug output
swift build && ./.build/arm64-apple-macosx/debug/BLFiMessageBot 2>&1 | tee debug.log
```

### Performance Monitoring
The app includes built-in metrics:
- Processing cycles counter
- Engine status monitoring
- Real-time cognitive state display

## 🎯 Key Benefits

### Stay in Your Comfort Zone
- **Keep VSCode** - Your familiar editor
- **Keep AI assistants** - Cursor, Copilot, etc.
- **Avoid Xcode** - No interface builder, no storyboards

### Professional Results
- **Native macOS app** - Full SwiftUI interface
- **Production ready** - Proper error handling
- **Self-contained** - No external dependencies

### Rapid Development
- **Instant feedback** - Build and test in seconds
- **AI-assisted coding** - Full intelligent assistance
- **Command-line friendly** - Script everything

## 🚦 Next Steps

1. **Launch the app**: `./launch-blf-app.sh`
2. **Edit Swift code** in VSCode with your AI assistant
3. **Rebuild and test** with the same script
4. **Never open Xcode** - Stay in your productive environment

The narrow bridge between chaos and control doesn't require leaving your AI-assisted development environment. The V-8 engine purrs just as beautifully when built from VSCode as it would from Xcode.

---

*This app demonstrates that sophisticated macOS development is possible entirely within VSCode, maintaining the Boolean Language Framework's principles while keeping modern AI development tools.* 