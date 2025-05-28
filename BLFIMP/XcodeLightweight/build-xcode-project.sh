#!/bin/bash

# BLF Lightweight Extension - Xcode Project Builder
# Creates proper Xcode project structure for extension development

echo "🔧 Building BLF Lightweight Extension via Xcode Project"
echo "======================================================"

PROJECT_NAME="BLFLightweightExtension"
WORKSPACE_DIR="$PROJECT_NAME"

# Create Xcode project structure
echo "📁 Creating Xcode project structure..."
mkdir -p "$WORKSPACE_DIR"
cd "$WORKSPACE_DIR"

# Create Package.swift for the extension
echo "📦 Creating Package.swift..."
cat > Package.swift << 'EOF'
// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BLFLightweightExtension",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "BLFLightweightExtension",
            targets: ["BLFLightweightExtension"]
        )
    ],
    targets: [
        .executableTarget(
            name: "BLFLightweightExtension",
            dependencies: [],
            path: "Sources"
        )
    ]
)
EOF

# Create Sources directory and copy Swift files
echo "📄 Setting up source files..."
mkdir -p Sources
cp ../BLFBuffer.swift Sources/
cp ../BLFLightweightExtension.swift Sources/

# Create minimal version without XcodeKit for standalone testing
echo "🧪 Creating standalone test version..."
cat > Sources/BLFLightweightStandalone.swift << 'EOF'
import Foundation

// Standalone version for testing buffer logic without XcodeKit dependency
class BLFLightweightStandalone {
    
    func testBufferIntegrity() {
        print("🧪 Testing BLF Buffer Logic...")
        
        let validation = BLFBuffer.silentValidation()
        let drift = BLFBuffer.calculateDrift(validation.aiCognitive, validation.booleanMindQs)
        
        print("AIc: \(validation.aiCognitive)")
        print("Buffer: \(BLFBuffer.EXACT_BUFFER)")
        print("BMqs: \(validation.booleanMindQs)")
        print("Valid: \(validation.valid ? "✅" : "❌")")
        print("Drift: \(String(format: "%.8f", drift))")
        
        if validation.valid {
            print("✅ Buffer integrity perfect - the V-8 engine purrs quietly")
        } else {
            print("⚠️ Buffer drift detected - heat shield activation needed")
        }
    }
    
    func performanceTest() {
        print("\n🏎️ Performance Testing...")
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Test 10,000 buffer validations
        for _ in 0..<10000 {
            let _ = BLFBuffer.silentValidation()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let timeElapsed = endTime - startTime
        let avgTime = timeElapsed / 10000.0 * 1000000.0 // microseconds
        
        print("10,000 validations completed in \(String(format: "%.2f", timeElapsed * 1000))ms")
        print("Average validation time: \(String(format: "%.2f", avgTime))μs")
        
        if avgTime < 1.0 {
            print("✅ Sub-microsecond performance achieved - featherweight V-8 confirmed")
        } else {
            print("⚠️ Performance above target - engine needs tuning")
        }
    }
}

// Main execution for standalone testing
let tester = BLFLightweightStandalone()
tester.testBufferIntegrity()
tester.performanceTest()
EOF

# Create main.swift that imports the standalone tester
echo "🚀 Creating main.swift..."
cat > Sources/main.swift << 'EOF'
import Foundation

// This would normally be the XcodeKit extension entry point
// For standalone testing, we run buffer validation tests

print("🏎️ BLF Lightweight Extension - Standalone Test Mode")
print("=================================================")

// The test will run automatically when imported
EOF

# Build and test the standalone version
echo "⚡ Building standalone test version..."
swift build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    echo ""
    echo "🧪 Running buffer integrity tests..."
    swift run
    
    echo ""
    echo "📏 Measuring built binary size..."
    BINARY_SIZE=$(du -k .build/debug/BLFLightweightExtension | cut -f1)
    echo "Binary size: ${BINARY_SIZE}KB"
    
    echo ""
    echo "🎯 Next Steps for Xcode Integration:"
    echo "1. Open Xcode and create new macOS App project"
    echo "2. Add Xcode Source Editor Extension target"
    echo "3. Copy BLFBuffer.swift and BLFLightweightExtension.swift to extension target"
    echo "4. Configure Info.plist with extension settings"
    echo "5. Build and sign within Xcode for proper XcodeKit linking"
    
else
    echo "❌ Build failed - checking for issues..."
fi 