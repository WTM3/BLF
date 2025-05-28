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
