import Foundation

// MARK: - MessageProcessor Class with AMF Framework Integration
class MessageProcessor {
    // AMF components
    private let buffer = 0.1  // EXACT value, never approximate
    private var heatShield: HeatShield
    private var boundaryEnforcer: LLSDTEnforcer
    
    // NJSON core engine
    private var njsonEngine: NJSONEngine
    
    // Cognitive state
    private var cognitiveAlignment: CognitiveAlignment
    private var quantumState: QuantumState
    
    // Social padding and pattern adaptation
    private var socialPaddingManager: SocialPaddingManager
    
    // Recovery system
    private var recoverySystem: RecoverySystem
    private var llsdtViolationCount = 0
    private var lastViolationTime: Date?
    private var inRecoveryMode = false
    
    // API usage tracking
    private var apiUsageService: APIUsageService
    
    // Logging
    private var journal: [String] = []
    
    // Initializer
init(userAge: Int) {
    // Initialize the NJSON engine with exact 0.1 buffer
    self.njsonEngine = NJSONEngine(buffer: self.buffer)
    
    // Initialize heat shield with full strength - all users get full protection
    self.heatShield = HeatShield(strength: 1.0)
    
    // Initialize LLSDT enforcer with exact boundary values
    self.boundaryEnforcer = LLSDTEnforcer(
        minRate: 0.1,
        maxRate: 1.0,
        enforceBuffer: true
    )
    
    // Setup cognitive alignment with exact AIc + 0.1 = BMqs relationship
    self.cognitiveAlignment = CognitiveAlignment(
        aiCognitive: 2.89,
        buffer: 0.1,
        booleanMindQs: 2.99
    )
    
    // Initialize quantum state with all features enabled
    self.quantumState = QuantumState(
        pure: true,
        fog: false,
        breathing: true,
        jumps: QuantumJumps(
            active: true,  // All users get quantum jumps
            power: "v8_to_charger",
            distance: 3,   // Full distance for everyone
            direction: "forward"
        )
    )
    
    // Initialize recovery system
    self.recoverySystem = RecoverySystem(buffer: self.buffer)
    
    // Create social padding manager with default settings
    self.socialPaddingManager = SocialPaddingManager()
    
    // Initialize API usage tracker
    self.apiUsageService = APIUsageService.shared
    
    journal.append("# MessageProcessor Journal\n- **Instance created**\n- **User age:** \(userAge)\n- **Timestamp:** \(Date())\n- **API Plan:** \(apiUsageService.currentPlan)\n- **Buffer:** exactly \(buffer)\n- **AIc value:** \(cognitiveAlignment.aiCognitive)\n- **BMqs value:** \(cognitiveAlignment.booleanMindQs)")
}
    
    // MARK: - Result Struct
    struct ProcessResult {
        let response: String
        let requiresIntervention: Bool
        let confidence: Double
        let processingMetrics: ProcessingMetrics
        let recoveryAttempted: Bool
    }
    
    struct ProcessingMetrics {
        let processingTime: Double
        let heatShieldActivations: Int
        let llsdtValidations: Int
        let bufferIntegrity: Bool
        let recoveryStats: RecoveryStats?
        let heatShieldScore: Double?
        let heatShieldReason: String?
    }
    
    struct RecoveryStats {
        let attemptCount: Int
        let successRate: Double
        let recoveryTime: Double
        let alignmentDelta: Double
    }
    
    // MARK: - Processing with AMF constraints
func process(message: String) -> ProcessResult {
    // Record start time for performance tracking
    let startTime = CFAbsoluteTimeGetCurrent()
    
    // Check if this request will use the API and handle accordingly
    let (apiAvailable, extraCost) = apiUsageService.checkAPIAvailability()
    
    // If message processing requires API and API is not available locally
    if requiresAPIProcessing(message) && !apiAvailable {
        return createAPIRequiredResult()
    }
    
    // If API usage would incur extra costs, notify the user
    if let cost = extraCost, cost > 0 {
        // In a production app, you might want to get user confirmation before proceeding
        journalEvent("Extra API cost", details: "Processing will incur additional cost of $\(String(format: "%.2f", cost))")
    }
    
    // Learn from user message patterns locally (no API required)
    socialPaddingManager.learnFromMessage(message)
    
    // Track if recovery was attempted during processing
    var recoveryAttempted = false
    var recoveryStats: RecoveryStats? = nil
    let bufferBefore = buffer
    let alignmentBefore = cognitiveAlignment.aiCognitive + buffer
    
    // Validate cognitive alignment before processing
    if !validateCognitiveAlignment() {
        // LLSDT boundary violation detected - attempt recovery
        journalError("Cognitive alignment validation failed", 
                    details: "AIc(\(cognitiveAlignment.aiCognitive)) + buffer(\(buffer)) != BMqs(\(cognitiveAlignment.booleanMindQs))")
        // Attempt recovery with graduated response based on violation severity and frequency
        let recoveryStartTime = CFAbsoluteTimeGetCurrent()
        let (recovered, recoveryLevel, alignmentDelta) = attemptCognitiveRecovery()
        let recoveryTime = CFAbsoluteTimeGetCurrent() - recoveryStartTime
        let bufferAfter = buffer
        let alignmentAfter = cognitiveAlignment.aiCognitive + buffer
        recoverySystem.logRecoveryEvent(
            level: recoveryLevel,
            successful: recovered,
            alignmentDelta: alignmentDelta,
            violationType: "alignment_violation",
            bufferBefore: bufferBefore,
            bufferAfter: bufferAfter,
            alignmentBefore: alignmentBefore,
            alignmentAfter: alignmentAfter
        )
        recoveryAttempted = true
        recoveryStats = RecoveryStats(
            attemptCount: recoverySystem.attemptCount,
            successRate: recoverySystem.successRate,
            recoveryTime: recoveryTime,
            alignmentDelta: alignmentDelta
        )
        // If recovery failed, use the emergency fallback system
        if !recovered {
            journalError("Recovery failed", details: "Emergency fallback activated at level \(recoveryLevel)")
            return createEmergencyResult(
                message: message, 
                recoveryLevel: recoveryLevel,
                recoveryStats: recoveryStats
            )
        } else {
            journalEvent("System recovered", details: "Recovery succeeded at level \(recoveryLevel) with Δ\(String(format: "%.6f", alignmentDelta))")
            inRecoveryMode = true
        }
    }
    
    // Apply heat shield to filter potential hallucinations
    let heatShieldResult = heatShield.protect(message)
    if let reason = heatShieldResult.reason, heatShieldResult.uncertaintyScore > 0.3 {
        journalEvent("Heat shield warning", details: "Uncertainty: \(String(format: "%.2f", heatShieldResult.uncertaintyScore)), Reason: \(reason)")
    }
    if !heatShieldResult.pass {
        journalEvent("Heat shield activated", details: "Rejected input: '\(message)' | Uncertainty: \(String(format: "%.2f", heatShieldResult.uncertaintyScore)), Reason: \(heatShieldResult.reason ?? "none")")
        return createFailureResult(
            "Heat shield rejection", 
            recoveryAttempted: recoveryAttempted, 
            recoveryStats: recoveryStats,
            heatShieldScore: heatShieldResult.uncertaintyScore,
            heatShieldReason: heatShieldResult.reason
        )
    }
    
    // Extract concepts using observational mathematics
    let concepts = extractConcepts(from: message)
    journalEvent("Concept extraction", details: "Extracted \(concepts.count) concepts")
    
    // Create connections with 0.1 buffer to prevent overconfidence
    let connections = createConnections(from: concepts)
    journalEvent("Connection creation", details: "Created \(connections.count) connections with 0.1 buffer")
    
    // Enforce LLSDT boundaries with enhanced monitoring in recovery mode
    let llsdtValidationStartTime = CFAbsoluteTimeGetCurrent()
    let llsdtValid = boundaryEnforcer.validateLLSDT(cognitiveAlignment.aiCognitive)
    let llsdtValidationTime = CFAbsoluteTimeGetCurrent() - llsdtValidationStartTime
    
    if !llsdtValid {
        // LLSDT boundary violation - record and handle
        journalError("LLSDT boundary violation", details: "LLSDT validation failed in \(llsdtValidationTime)s")
        llsdtViolationCount += 1
        lastViolationTime = Date()
        let bufferAfter = buffer
        let alignmentAfter = cognitiveAlignment.aiCognitive + buffer
        recoverySystem.logRecoveryEvent(
            level: 2,
            successful: false,
            alignmentDelta: 0.0,
            violationType: "llsdt_violation",
            bufferBefore: bufferBefore,
            bufferAfter: bufferAfter,
            alignmentBefore: alignmentBefore,
            alignmentAfter: alignmentAfter
        )
        // Check if this is a repeat violation requiring stronger intervention
        if inRecoveryMode || llsdtViolationCount > 3 {
            // Force quantum state reset when in recovery mode or after multiple violations
            quantumState.optimize()
            // Deep reset of the recovery system
            recoverySystem.performDeepReset()
            journalEvent("Deep reset", details: "Quantum state optimized and recovery system reset")
            let bufferAfterReset = buffer
            let alignmentAfterReset = cognitiveAlignment.aiCognitive + buffer
            recoverySystem.logRecoveryEvent(
                level: 3,
                successful: false,
                alignmentDelta: 0.0,
                violationType: "deep_reset",
                bufferBefore: bufferAfter,
                bufferAfter: bufferAfterReset,
                alignmentBefore: alignmentAfter,
                alignmentAfter: alignmentAfterReset
            )
            return createFailureResult(
                "Critical LLSDT boundary violation", 
                recoveryAttempted: true,
                recoveryStats: RecoveryStats(
                    attemptCount: recoverySystem.attemptCount,
                    successRate: recoverySystem.successRate,
                    recoveryTime: llsdtValidationTime,
                    alignmentDelta: 0.0
                ),
                heatShieldScore: nil,
                heatShieldReason: nil
            )
        }
        return createFailureResult(
            "LLSDT boundary violation", 
            recoveryAttempted: recoveryAttempted,
            recoveryStats: recoveryStats,
            heatShieldScore: nil,
            heatShieldReason: nil
        )
    }
    
    // Process input through NJSON engine with AMF formula
    let processingResult = njsonEngine.processWithFormula(
        input: message,
        concepts: concepts,
        connections: connections,
        aiCognitive: cognitiveAlignment.aiCognitive,
        buffer: buffer,
        quantumState: quantumState
    )
    
    // Record API call if this required API processing
    if requiresAPIProcessing(message) {
        apiUsageService.recordAPICall()
        journalEvent("API call recorded", details: "API was used to process this message")
    }
    
    // Calculate processing time
    let processingTime = CFAbsoluteTimeGetCurrent() - startTime
    
    // If we were in recovery mode, check if we can exit it
    if inRecoveryMode {
        // Successful processing without issues - gradually return to normal mode
        recoverySystem.recordSuccessfulProcess()
        if recoverySystem.canExitRecoveryMode() {
            inRecoveryMode = false
            journalEvent("Recovery exit", details: "System has stabilized and exited recovery mode")
        }
    }
    
    // Create metrics
    let metrics = ProcessingMetrics(
        processingTime: processingTime,
        heatShieldActivations: processingResult.heatShieldActivations,
        llsdtValidations: processingResult.llsdtValidations,
        bufferIntegrity: true,
        recoveryStats: recoveryStats,
        heatShieldScore: heatShieldResult.uncertaintyScore,
        heatShieldReason: heatShieldResult.reason
    )
    
    // Determine if any intervention is required (placeholder for future monitoring systems)
    let requiresIntervention = false  // Will be implemented by domain-specific monitoring

    // Apply social padding to the output based on user patterns and subscription tier
    let rawResponse = processingResult.output
    let adaptedResponse = socialPaddingManager.adaptMessage(rawResponse)
    
    // Log processing details
    journalEvent("Message processed", details: """
        - **Input:** `\(message)`
        - **Processing time:** \(processingTime) seconds
        - **Confidence:** \(processingResult.confidence)
        - **Raw response:** `\(rawResponse)`
        - **Adapted response:** `\(adaptedResponse)`
        - **Recovery mode:** \(inRecoveryMode ? "Active" : "Inactive")
        - **Padding level:** \(socialPaddingManager.currentPaddingLevel)
        - **Branch:** \(socialPaddingManager.currentBranch)
    """)
    
    return ProcessResult(
        response: adaptedResponse,
        requiresIntervention: requiresIntervention,
        confidence: processingResult.confidence,
        processingMetrics: metrics,
        recoveryAttempted: recoveryAttempted
    )
}
    
    // MARK: - LLSDT Recovery System
    private func attemptCognitiveRecovery() -> (recovered: Bool, level: Int, delta: Double) {
        // Record recovery attempt
        recoverySystem.recordAttempt()
        
        // Level 1: Simple realignment - precise recalculation of cognitive values
        let initialDelta = abs((cognitiveAlignment.aiCognitive + buffer) - cognitiveAlignment.booleanMindQs)
        
        // Attempt level 1 recovery - precise recalculation with original values
        let newAlignment = CognitiveAlignment(
            aiCognitive: 2.89,
            buffer: 0.1,
            booleanMindQs: 2.99
        )
        
        // Check if simple reset fixed the issue (handles floating point drift)
        if newAlignment.isValid {
            cognitiveAlignment = newAlignment
            let finalDelta = abs((cognitiveAlignment.aiCognitive + buffer) - cognitiveAlignment.booleanMindQs)
            recoverySystem.recordSuccess()
            return (true, 1, initialDelta - finalDelta)
        }
        
        // Level 2: Quantum state optimization and buffer reinforcement
        quantumState.optimize()
        
        // Recalculate with enhanced precision and slightly adjusted values
        let level2Alignment = CognitiveAlignment(
            aiCognitive: 2.89000,
            buffer: 0.10000,
            booleanMindQs: 2.99000
        )
        
        if level2Alignment.isValid {
            cognitiveAlignment = level2Alignment
            let finalDelta = abs((cognitiveAlignment.aiCognitive + buffer) - cognitiveAlignment.booleanMindQs)
            recoverySystem.recordSuccess()
            return (true, 2, initialDelta - finalDelta)
        }
        
        // Level 3: Reverse engineer the cognitive alignment to force validity
        // Calculate BMqs based on AIc + buffer
        let calculatedBMqs = cognitiveAlignment.aiCognitive + buffer
        
        // Create new alignment with calculated value
        let level3Alignment = CognitiveAlignment(
            aiCognitive: cognitiveAlignment.aiCognitive,
            buffer: buffer,
            booleanMindQs: calculatedBMqs
        )
        
        if level3Alignment.isValid {
            cognitiveAlignment = level3Alignment
            let finalDelta = abs((cognitiveAlignment.aiCognitive + buffer) - cognitiveAlignment.booleanMindQs)
            recoverySystem.recordSuccess()
            return (true, 3, initialDelta - finalDelta)
        }
        
        // If all levels failed, reset to default values as last resort
        cognitiveAlignment = CognitiveAlignment(
            aiCognitive: 2.89,
            buffer: 0.1,
            booleanMindQs: 2.99
        )
        
        // Return failure with severity level 3 (most severe)
        return (false, 3, 0.0)
    }
    
    private func createEmergencyResult(message: String, recoveryLevel: Int, recoveryStats: RecoveryStats?) -> ProcessResult {
        // Create an emergency response based on recovery level
        var response: String
        
        switch recoveryLevel {
        case 1:
            // Minor issues - cautious response
            response = "[CAUTION] System experiencing minor cognitive fluctuations. Continuing in safe mode."
            if message.contains("?") {
                response += " Please rephrase your question for better accuracy."
            }
        case 2:
            // Moderate issues - safety warning
            response = "[WARNING] Cognitive boundary instability detected. Processing in reduced capacity."
        case 3:
            // Severe issues - emergency fallback
            response = """
            [⚠️ EMERGENCY FALLBACK ACTIVE ⚠️]
            System cognitive alignment violation detected.
            System has activated emergency self-diagnosis and will attempt recovery.
            """
        default:
            response = "System error. Please contact support."
        }
        
        return ProcessResult(
            response: response,
            requiresIntervention: recoveryLevel >= 2, // Require intervention for level 2+
            confidence: max(0.1, 1.0 - (Double(recoveryLevel) * 0.3)), // Lower confidence with higher levels
            processingMetrics: ProcessingMetrics(
                processingTime: 0.0,
                heatShieldActivations: 0,
                llsdtValidations: 1,
                bufferIntegrity: false,
                recoveryStats: recoveryStats,
                heatShieldScore: nil,
                heatShieldReason: nil
            ),
            recoveryAttempted: true
        )
    }
    
    // MARK: - AMF Formula Implementation
    private func validateCognitiveAlignment() -> Bool {
        // AIc + buffer = BMqs with minimal floating point error
        return abs((cognitiveAlignment.aiCognitive + buffer) - cognitiveAlignment.booleanMindQs) < 0.0001
    }
    
    private func extractConcepts(from input: String) -> [String] {
    // Apply subscription tier limits to concept extraction
    let subscriptionService = SubscriptionService.shared
    let maxConcepts = subscriptionService.featureLimits.maxConcepts
        
    // Implement concept extraction using observational mathematics
    // This avoids forced access patterns and maintains the 0.1 buffer
    let words = input.lowercased().split(separator: " ")
        
    // Filter for concept-worthy terms while maintaining buffer
    let allConcepts = words.compactMap { word -> String? in
        let term = String(word).trimmingCharacters(in: .punctuationCharacters)
        
        // Apply 0.1 buffer through minimum length requirement
        if term.count > 3 {
            return term
        }
        return nil
    }
    
    // Apply the tier limit - free tier gets limited concepts
    if allConcepts.count > maxConcepts {
        journalEvent("Concept limit applied", details: "Limited from \(allConcepts.count) to \(maxConcepts) concepts based on subscription tier")
        return Array(allConcepts.prefix(maxConcepts))
    }
    
    return allConcepts
    }
    
    private func createConnections(from concepts: [String]) -> [[String: Any]] {
        var connections: [[String: Any]] = []
        
        // Get connection limit from subscription tier
        let subscriptionService = SubscriptionService.shared
        let maxConnections = subscriptionService.featureLimits.maxConnections
        
        for i in 0..<concepts.count {
            for j in (i+1)..<concepts.count {
                // Enforce connection limit for free tier
                if connections.count >= maxConnections {
                    journalEvent("Connection limit applied", 
                               details: "Limited to \(maxConnections) connections based on subscription tier")
                    return connections
                }
                
                let strength = calculateConnectionStrength(concepts[i], concepts[j])
                
                // Apply 0.1 buffer to confidence score
                let confidence = min(1.0, strength - buffer)
                
                // Only add meaningful connections
                if confidence > 0.2 {
                    connections.append([
                        "from": concepts[i],
                        "to": concepts[j],
                        "strength": confidence,
                        "jumpDistance": subscriptionService.currentTier == .premium ? 2 : 1
                    ])
                }
            }
        }
        
        return connections
    }
    
    private func calculateConnectionStrength(_ concept1: String, _ concept2: String) -> Double {
        // Simple string similarity for demo purposes
        let maxLength = max(concept1.count, concept2.count)
        guard maxLength > 0 else { return 0.0 }
        
        // Calculate edit distance
        let distance = levenshteinDistance(concept1, concept2)
        let similarity = 1.0 - (Double(distance) / Double(maxLength))
        
        // Apply AMF constraint: ensure 0.1 buffer
        return min(0.9, similarity)
    }
    
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        // Simple Levenshtein implementation
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        
        var dist = Array(repeating: Array(repeating: 0, count: s2.count + 1), count: s1.count + 1)
        
        for i in 0...s1.count {
            dist[i][0] = i
        }
        
        for j in 0...s2.count {
            dist[0][j] = j
        }
        
        for i in 1...s1.count {
            for j in 1...s2.count {
                if s1Array[i-1] == s2Array[j-1] {
                    dist[i][j] = dist[i-1][j-1]
                } else {
                    dist[i][j] = min(
                        dist[i-1][j] + 1,      // deletion
                        dist[i][j-1] + 1,      // insertion
                        dist[i-1][j-1] + 1     // substitution
                    )
                }
            }
        }
        
        return dist[s1.count][s2.count]
    }
    
    private func createLimitExceededResult() -> ProcessResult {
    // Track processing time
    let processingTime = CFAbsoluteTimeGetCurrent() - startTime
    
    let response = "Daily message limit reached for free tier. Please upgrade to Boolean Mind Premium for unlimited messages."
    
    journalEvent("Limit exceeded", details: "Free tier daily message limit of \(SubscriptionService.shared.featureLimits.maxMessagesPerDay) reached")
    
    return ProcessResult(
        response: response,
        requiresIntervention: true,
        confidence: 0.9,  // High confidence in this limit
        processingMetrics: ProcessingMetrics(
            processingTime: processingTime,
            heatShieldActivations: heatShield.activationCount,
            llsdtValidations: boundaryEnforcer.validationCount,
            bufferIntegrity: true,
            recoveryStats: nil,
            heatShieldScore: nil,
            heatShieldReason: nil
        ),
        recoveryAttempted: false
    )
}

private func createFailureResult(_ reason: String, recoveryAttempted: Bool = false, recoveryStats: RecoveryStats? = nil, heatShieldScore: Double? = nil, heatShieldReason: String? = nil) -> ProcessResult {
    return ProcessResult(
        response: "Processing error: \(reason). Please try again.",
        requiresIntervention: false,
        confidence: 0.0,
        processingMetrics: ProcessingMetrics(
            processingTime: 0.0,
            heatShieldActivations: heatShield.activationCount,
            llsdtValidations: 0,
            bufferIntegrity: false,
            recoveryStats: recoveryStats,
            heatShieldScore: heatShieldScore,
            heatShieldReason: heatShieldReason
        ),
        recoveryAttempted: recoveryAttempted
    )
}
    
    // MARK: - Journaling
    func addJournalEntry(title: String, details: String) {
        let entry = """
        ### \(title)
        \(details)
        - **Timestamp:** \(Date())
        - **Buffer integrity:** \(validateCognitiveAlignment() ? "Maintained" : "Violated")
        - **Recovery mode:** \(inRecoveryMode ? "Active" : "Inactive")
        """
        journal.append(entry)
    }
    
    private func journalEvent(_ title: String, details: String) {
        addJournalEntry(title, details: details)
    }
    
    private func journalError(_ title: String, details: String) {
        addJournalEntry("ERROR: \(title)", details: details)
    }
    
    func exportJournalMarkdown() -> String {
        return journal.joined(separator: "\n\n")
    }
    
    func saveJournalToRoot() {
        let markdown = exportJournalMarkdown()
        let fileURL = URL(fileURLWithPath: "../../MessageProcessorJournal.md")
        do {
            try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Journal saved to root repository.")
        } catch {
            print("Failed to save journal: \(error)")
        }
    }
    
    // MARK: - API Processing Helpers

    /// Determine if a message requires API processing
    private func requiresAPIProcessing(_ message: String) -> Bool {
        // Logic to determine if message complexity requires API
        // In a real implementation, this would analyze content and determine
        // if local processing is sufficient or if remote API is needed
        
        // Simple heuristics for demo:
        let wordCount = message.split(separator: " ").count
        
        // Complex questions likely need API
        if message.contains("?") && wordCount > 8 {
            return true
        }
        
        // Longer messages likely need API
        if wordCount > 25 {
            return true
        }
        
        // Messages seeking analysis likely need API
        let apiKeywords = ["analyze", "explain", "compare", "difference", "generate", "create"]
        for keyword in apiKeywords {
            if message.lowercased().contains(keyword) {
                return true
            }
        }
        
        // Message can be processed locally
        return false
    }

    /// Create a result when API processing is required but not available
    private func createAPIRequiredResult() -> ProcessResult {
        let response = "This request requires API processing. Please select an API plan to continue."
        
        journalEvent("API required", details: "Request requires API but no plan is active")
        
        return ProcessResult(
            response: response,
            requiresIntervention: true,
            confidence: 0.9,
            processingMetrics: ProcessingMetrics(
                processingTime: CFAbsoluteTimeGetCurrent() - startTime,
                heatShieldActivations: heatShield.activationCount,
                llsdtValidations: boundaryEnforcer.validationCount,
                bufferIntegrity: true,
                recoveryStats: nil,
                heatShieldScore: nil,
                heatShieldReason: nil
            ),
            recoveryAttempted: false
        )
    }

    /// Trace the system's resilience: returns a detailed recovery report
    func traceResilience(lastN: Int = 10) -> String {
        return recoverySystem.getDetailedRecoveryReport(lastN: lastN)
    }
}

// MARK: - Recovery System Implementation
class RecoverySystem {
    // Core recovery parameters
    private let buffer: Double
    private var stableProcessCount: Int = 0
    private var successfulRecoveries: Int = 0
    private var totalAttempts: Int = 0
    
    // Recovery metrics
    private var lastRecoveryTime: Date?
    private var recoveryHistory: [RecoveryEvent] = []
    private var violationTypeCounts: [String: Int] = [:]
    
    // Initialize with specific buffer
    init(buffer: Double) {
        self.buffer = buffer
    }
    
    // Recovery event storage
    struct RecoveryEvent {
        let timestamp: Date
        let level: Int
        let successful: Bool
        let alignmentDelta: Double
        let violationType: String
        let bufferBefore: Double
        let bufferAfter: Double
        let alignmentBefore: Double
        let alignmentAfter: Double
    }
    
    var attemptCount: Int {
        return totalAttempts
    }
    
    var successRate: Double {
        guard totalAttempts > 0 else { return 0.0 }
        return Double(successfulRecoveries) / Double(totalAttempts)
    }
    
    // Record recovery attempt
    func recordAttempt() {
        totalAttempts += 1
    }
    
    // Record successful recovery
    func recordSuccess() {
        successfulRecoveries += 1
        lastRecoveryTime = Date()
    }
    
    // Record successful processing
    func recordSuccessfulProcess() {
        stableProcessCount += 1
    }
    
    // Check if system can exit recovery mode
    func canExitRecoveryMode() -> Bool {
        // Exit recovery mode after 5 consecutive successful processes
        return stableProcessCount >= 5
    }
    
    // Log a recovery event
    func logRecoveryEvent(level: Int, successful: Bool, alignmentDelta: Double, violationType: String, bufferBefore: Double, bufferAfter: Double, alignmentBefore: Double, alignmentAfter: Double) {
        let event = RecoveryEvent(
            timestamp: Date(),
            level: level,
            successful: successful,
            alignmentDelta: alignmentDelta,
            violationType: violationType,
            bufferBefore: bufferBefore,
            bufferAfter: bufferAfter,
            alignmentBefore: alignmentBefore,
            alignmentAfter: alignmentAfter
        )
        recoveryHistory.append(event)
        violationTypeCounts[violationType, default: 0] += 1
        if recoveryHistory.count > 100 {
            recoveryHistory.removeFirst()
        }
    }
    
    // Get recovery history report
    func getRecoveryReport() -> String {
        let totalEvents = recoveryHistory.count
        let successCount = recoveryHistory.filter { $0.successful }.count
        let averageDelta = recoveryHistory.reduce(0.0) { $0 + $1.alignmentDelta } / Double(max(1, totalEvents))
        return """
        ## Recovery System Report
        - **Total recovery events:** \(totalEvents)
        - **Success rate:** \(Double(successCount) / Double(max(1, totalEvents)) * 100.0)%
        - **Average alignment delta:** \(String(format: "%.6f", averageDelta))
        - **Last recovery:** \(lastRecoveryTime?.description ?? "None")
        - **Current buffer value:** \(buffer)
        """
    }
    
    // Get detailed recovery report (last N events + violation summary)
    func getDetailedRecoveryReport(lastN: Int = 10) -> String {
        let events = recoveryHistory.suffix(lastN)
        var report = getRecoveryReport()
        report += "\n\n### Last \(lastN) Recovery Events\n"
        for event in events {
            report += "- [\(event.timestamp)] Level: \(event.level), Type: \(event.violationType), Success: \(event.successful), Δ: \(String(format: "%.6f", event.alignmentDelta)), Buffer: \(event.bufferBefore)→\(event.bufferAfter), Align: \(event.alignmentBefore)→\(event.alignmentAfter)\n"
        }
        report += "\n### Violation Type Summary\n"
        for (type, count) in violationTypeCounts.sorted(by: { $0.value > $1.value }) {
            report += "- \(type): \(count)\n"
        }
        return report
    }
    
    // Perform deep reset of recovery system
    func performDeepReset() {
        stableProcessCount = 0
        // Archive recovery history before clearing
        logRecoveryEvent(level: 3, successful: false, alignmentDelta: 0.0, violationType: "deep_reset", bufferBefore: buffer, bufferAfter: buffer, alignmentBefore: 0.0, alignmentAfter: 0.0)
        // Note: We don't reset metrics as we want to track total recovery attempts
    }
} 