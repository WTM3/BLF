import SwiftUI
import BLFNJSONBridge

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
}

// MARK: - BLFAppState for the standalone app
@MainActor
class BLFAppState: ObservableObject {
    // NJSON singleton for all business logic - the V-8 under the hood
    private let njson = NJSON.shared
    
    // UI state (minimal, just for display)
    @Published var isRunning = false
    @Published var activeBranch: Branch = .familyFriends
    @Published var socialPadding: SocialPadding = .medium
    @Published var statusMessage = "Initializing..."
    @Published var messageCount = 0
    @Published var processingCycles = 0
    @Published var errorCount = 0
    @Published var logs: [String] = []
    @Published var conversations: [ConversationMessage] = []
    @Published var currentInput = ""
    @Published var isProcessing = false
    
    // Direct input for better responsiveness
    func updateInput(_ newValue: String) {
        currentInput = newValue
    }
    
    // Timer for UI updates
    private var updateTimer: Timer?
    
    func initialize() async {
        // Set initial state immediately
        DispatchQueue.main.async {
            self.statusMessage = "Initializing V-8 engine..."
            self.isRunning = false
        }
        
        // Initialize NJSON in background
        Task.detached { [weak self] in
            do {
                try await self?.njson.initialize()
                
                // Update UI on main thread
                await MainActor.run { [weak self] in
                    self?.statusMessage = "Ready - The narrow bridge between chaos and control"
                    self?.isRunning = true
                    
                    // Start timer for live updates
                    self?.updateTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
                        Task { [weak self] in
                            await self?.refreshState()
                        }
                    }
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.statusMessage = "Initialization failed: \(error.localizedDescription)"
                    self?.isRunning = false
                }
            }
        }
    }
    
    func startBot() async {
        guard !isRunning else { return }
        
        DispatchQueue.main.async {
            self.isRunning = true
            self.statusMessage = "Running - V-8 engine purring"
        }
        
        await refreshState()
    }
    
    func stopBot() async {
        guard isRunning else { return }
        
        DispatchQueue.main.async {
            self.isRunning = false
            self.statusMessage = "Stopped"
        }
        
        await refreshState()
    }
    
    func setBranch(_ branch: Branch) async {
        await njson.setBranch(branch)
        DispatchQueue.main.async {
            self.activeBranch = branch
        }
    }
    
    func setPadding(_ padding: SocialPadding) async {
        await njson.setPadding(padding)
        DispatchQueue.main.async {
            self.socialPadding = padding
        }
    }
    
    func refreshState() async {
        let cognitiveState = await njson.getCognitiveState()
        
        DispatchQueue.main.async {
            self.processingCycles = self.processingCycles + 1
            self.logs = [
                "Cognitive State: \(cognitiveState.formula)",
                "Buffer: \(cognitiveState.buffer)",
                "Alignment: \(cognitiveState.alignment ? "✅ Maintained" : "⚠️ Violation")",
                "Initialized: \(cognitiveState.initialized ? "Yes" : "No")",
                "Last update: \(DateFormatter.timeFormatter.string(from: Date()))"
            ]
        }
    }
    
    func sendMessage() async {
        guard !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard !isProcessing else { return }
        
        let message = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add user message to conversation and clear input immediately
        DispatchQueue.main.async {
            self.conversations.append(ConversationMessage(
                content: message,
                isUser: true,
                timestamp: Date()
            ))
            self.currentInput = ""
            self.isProcessing = true
        }
        
        // Process in background without blocking UI
        Task.detached { [weak self] in
            do {
                // Process through the V-8 engine
                let result = try await self?.njson.processText(message, bmId: "user")
                
                // Add response to conversation
                await MainActor.run { [weak self] in
                    if let result = result {
                        self?.conversations.append(ConversationMessage(
                            content: result.text,
                            isUser: false,
                            timestamp: Date(),
                            confidence: result.cognitiveAlignment ? 0.9 : 0.5,
                            bufferIntact: result.cognitiveAlignment
                        ))
                        self?.messageCount += 1
                    }
                    self?.isProcessing = false
                }
                
                // Refresh state in background
                await self?.refreshState()
                
            } catch {
                // Handle error
                await MainActor.run { [weak self] in
                    self?.conversations.append(ConversationMessage(
                        content: "❌ Engine error: \(error.localizedDescription)",
                        isUser: false,
                        timestamp: Date(),
                        confidence: 0.0,
                        bufferIntact: false
                    ))
                    self?.isProcessing = false
                }
            }
        }
    }
}

// MARK: - ConversationMessage Model
struct ConversationMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    var confidence: Double = 1.0
    var bufferIntact: Bool = true
}

// MARK: - Main Content View
struct ContentView: View {
    @EnvironmentObject private var appState: BLFAppState
    
    var body: some View {
        NavigationView {
            // Sidebar
            List {
                NavigationLink(destination: DashboardView()) {
                    Label("Dashboard", systemImage: "speedometer")
                }
                NavigationLink(destination: ChatView()) {
                    Label("Chat with V-8", systemImage: "message")
                }
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
                NavigationLink(destination: LogsView()) {
                    Label("Logs", systemImage: "list.bullet")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 150)
            
            // Default view
            DashboardView()
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

// MARK: - Dashboard View
struct DashboardView: View {
    @EnvironmentObject private var appState: BLFAppState
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Boolean Language Framework")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("The V-8 Under the Hood")
                .font(.title2)
                .foregroundColor(.secondary)
            
            // Status card
            StatusCard()
            
            // Controls
            HStack(spacing: 20) {
                Button(action: {
                    if appState.isRunning {
                        Task { await appState.stopBot() }
                    } else {
                        Task { await appState.startBot() }
                    }
                }) {
                    HStack {
                        Image(systemName: appState.isRunning ? "stop.fill" : "play.fill")
                        Text(appState.isRunning ? "Stop Engine" : "Start Engine")
                    }
                    .frame(width: 150)
                }
                .buttonStyle(DefaultButtonStyle())
                .controlSize(.large)
                
                Spacer()
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Status Card
struct StatusCard: View {
    @EnvironmentObject private var appState: BLFAppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(appState.isRunning ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                Text(appState.isRunning ? "Engine Running" : "Engine Stopped")
                    .font(.headline)
                    .foregroundColor(appState.isRunning ? .green : .red)
                Spacer()
            }
            
            Text("Status: \(appState.statusMessage)")
                .foregroundColor(.secondary)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Processing Cycles")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(appState.processingCycles)")
                        .font(.title)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Messages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(appState.messageCount)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .trailing) {
                    Text("Branch")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(appState.activeBranch.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(.textBackgroundColor))
        .cornerRadius(10)
    }
}

// MARK: - Chat View
struct ChatView: View {
    @EnvironmentObject private var appState: BLFAppState
    @State private var inputText = ""
    @State private var testMessages: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Chat with the V-8 Engine")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("The narrow bridge between chaos and control")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Engine status indicator
                HStack {
                    Circle()
                        .fill(appState.isRunning ? Color.green : Color.orange)
                        .frame(width: 8, height: 8)
                    Text(appState.isRunning ? "Engine Ready" : "Engine Initializing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button("Refresh") {
                        Task {
                            await appState.refreshState()
                        }
                    }
                    .font(.caption)
                }
            }
            .padding()
            
            Divider()
            
            // Conversation area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        if appState.conversations.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "engine.combustion")
                                    .font(.system(size: 48))
                                    .foregroundColor(appState.isRunning ? .green : .orange)
                                
                                if appState.isRunning {
                                    Text("Chat with the Boolean Language Framework")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Type a message below to experience the V-8 engine with the exact 0.1 buffer")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                } else {
                                    Text("Engine Starting...")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Please wait for the V-8 engine to warm up, or click 'Start Engine' in Dashboard")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        } else {
                            ForEach(appState.conversations) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        
                        if appState.isProcessing {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("V-8 engine processing...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading)
                        }
                    }
                    .padding()
                }
                .onChange(of: appState.conversations.count) { _ in
                    if let lastMessage = appState.conversations.last {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider()
            
            // Input area - Full V-8 engine chat
            HStack(spacing: 12) {
                TextField("Chat with the V-8 engine...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    sendCurrentMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .blue)
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }
    
    private func sendCurrentMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Update app state and send
        appState.currentInput = inputText
        inputText = "" // Clear immediately
        
        Task {
            await appState.sendMessage()
        }
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    let message: ConversationMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .frame(maxWidth: 300, alignment: .trailing)
                    
                    Text(DateFormatter.timeFormatter.string(from: message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "engine.combustion")
                            .foregroundColor(.orange)
                            .frame(width: 20)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(message.content)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.textBackgroundColor))
                                .cornerRadius(16)
                                .frame(maxWidth: 300, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                Text(DateFormatter.timeFormatter.string(from: message.timestamp))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                
                                if !message.bufferIntact {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                        .font(.caption2)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption2)
                                }
                                
                                Text("Confidence: \(String(format: "%.1f", message.confidence))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject private var appState: BLFAppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Engine Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Branch selection
            VStack(alignment: .leading) {
                Text("Communication Branch")
                    .font(.headline)
                
                Picker("", selection: Binding(
                    get: { appState.activeBranch },
                    set: { newBranch in
                        Task { await appState.setBranch(newBranch) }
                    }
                )) {
                    Text("Family & Friends").tag(Branch.familyFriends)
                    Text("Professional").tag(Branch.professional)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 5)
                
                Text("Select how the engine should communicate")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom)
            
            // Padding selection
            VStack(alignment: .leading) {
                Text("Social Padding Level")
                    .font(.headline)
                
                Picker("", selection: Binding(
                    get: { appState.socialPadding },
                    set: { newPadding in
                        Task { await appState.setPadding(newPadding) }
                    }
                )) {
                    Text("More").tag(SocialPadding.more)
                    Text("Medium").tag(SocialPadding.medium)
                    Text("None").tag(SocialPadding.none)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 5)
                
                Text("Controls the narrow bridge between chaos and control")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Logs View
struct LogsView: View {
    @EnvironmentObject private var appState: BLFAppState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Engine Logs")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if appState.logs.isEmpty {
                Text("No logs to display")
                    .foregroundColor(.secondary)
                    .padding(.top)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(appState.logs.indices, id: \.self) { index in
                            Text(appState.logs[index])
                                .font(.system(.body, design: .monospaced))
                                .padding(.vertical, 2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
            
            Button("Refresh Engine State") {
                Task {
                    await appState.refreshState()
                }
            }
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Main App
@main
struct BLFiMessageBotApp: App {
    @StateObject private var appState = BLFAppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    // Initialize in background to prevent blocking
                    Task.detached {
                        await appState.initialize()
                    }
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
} 