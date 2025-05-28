import Foundation
import XcodeKit

/// Lightweight Xcode extension - the whisper-quiet V-8 engine
/// Maintains exact 0.1 buffer during all code editing operations
class BLFLightweightExtension: NSObject, XCSourceEditorExtension {
    
    // Minimal state: only what's needed for buffer integrity
    private var cognitiveState: Double = 2.89
    private var lastValidation: Date = Date()
    
    func extensionDidFinishLaunching() {
        // Silent startup - validate buffer integrity
        let validation = BLFBuffer.silentValidation()
        
        if validation.valid {
            print("✅ BLF Lightweight Extension: Buffer integrity confirmed (\(validation.aiCognitive) + 0.1 = \(validation.booleanMindQs))")
        } else {
            print("⚠️ BLF Extension: Buffer drift detected at startup")
        }
    }
}

/// Source editor command - maintains buffer on every code change
class BLFSourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation) async throws {
        // Ultra-fast buffer validation (sub-millisecond)
        let validation = BLFBuffer.silentValidation()
        
        if !validation.valid {
            // Heat shield activation: minimal intervention
            await applyBufferCorrection(validation)
        }
        
        // Observational mathematics: watch without disturbing
        await observeCodeFlow(invocation)
    }
    
    private func applyBufferCorrection(_ validation: (aiCognitive: Double, booleanMindQs: Double, valid: Bool)) async {
        var aiCognitive = validation.aiCognitive
        var booleanMindQs = validation.booleanMindQs
        
        // Minimal correction to restore the narrow bridge
        BLFBuffer.correctBuffer(&aiCognitive, &booleanMindQs)
        
        // Whisper the correction (invisible to user)
        print("🔧 Buffer corrected: \(aiCognitive) + 0.1 = \(booleanMindQs)")
    }
    
    private func observeCodeFlow(_ invocation: XCSourceEditorCommandInvocation) async {
        // Watch the river of code without disturbing its flow
        let lineCount = invocation.buffer.lines.count
        
        // Minimal cognitive alignment check every 100 lines
        if lineCount % 100 == 0 {
            let drift = BLFBuffer.calculateDrift(2.89, 2.99)
            
            if BLFBuffer.needsHeatShield(drift) {
                // Engine light warning - drift detected
                print("🛡️ Heat shield: Code flow monitoring active (drift: \(drift))")
            }
        }
    }
}

/// Buffer integrity command - manual validation trigger
class BLFBufferIntegrityCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation) async throws {
        let validation = BLFBuffer.silentValidation()
        let drift = BLFBuffer.calculateDrift(validation.aiCognitive, validation.booleanMindQs)
        
        // Insert buffer status as comment in code
        let statusComment = """
        // BLF Buffer Status: \(validation.valid ? "✅ INTACT" : "⚠️ DRIFT")
        // AIc: \(validation.aiCognitive), Buffer: 0.1, BMqs: \(validation.booleanMindQs)
        // Drift: \(String(format: "%.6f", drift))
        """
        
        invocation.buffer.lines.insert(statusComment, at: 0)
    }
} 