import SwiftUI
import AVFoundation

/// A drop-in voice agent view with form, animated orb, and session management.
///
/// Usage:
/// ```swift
/// VoiceAgentView(config: .default)
/// VoiceAgentView(config: .default, initialAgentType: "legalAdviser")
/// ```
public struct VoiceAgentView: View {
    @StateObject private var viewModel: VoiceAgentViewModel
    @State private var hasPermission = false
    @State private var showForm = true

    @State private var nameField = ""
    @State private var subjectField = ""
    @State private var languageField = "English"
    @State private var typeField: String

    // Staggered fade-in states
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showTagline = false
    @State private var showOrb = false
    @State private var showStatus = false
    @State private var showFooter = false

    private let config: VoiceAgentConfig
    private let languages = ["English", "Hindi", "Hinglish"]

    private var activeConfig: AgentTypeConfig {
        config.agentTypes.first(where: { $0.id == typeField }) ?? config.agentTypes.first!
    }
    private var theme: AgentTheme { activeConfig.theme }

    public init(config: VoiceAgentConfig = .default, initialAgentType: String = "") {
        self.config = config
        let resolvedType = initialAgentType.isEmpty ? config.defaultAgentType : initialAgentType
        _typeField = State(initialValue: resolvedType)
        _viewModel = StateObject(wrappedValue: VoiceAgentViewModel(config: config))
    }

    public var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            if showForm && (viewModel.state == .idle || viewModel.state == .disconnected) {
                formView.transition(.opacity)
            } else {
                sessionView.transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showForm)
        .onAppear { checkMicPermission() }
        .onDisappear { viewModel.disconnect() }
        .preferredColorScheme(.dark)
    }

    // MARK: - Form View

    private var formView: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 0)

                    Text(activeConfig.title)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .tracking(-0.5)
                        .foregroundStyle(
                            LinearGradient(colors: theme.titleGradient, startPoint: .leading, endPoint: .trailing)
                        )

                    Text("Tell us about yourself to get started")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(theme.subtleTextColor)

                    VStack(spacing: 14) {
                        formField(icon: "person.fill", placeholder: "Your Name", text: $nameField)
                        formField(icon: "bubble.left.fill", placeholder: activeConfig.subjectPlaceholder, text: $subjectField)

                        // Language picker
                        segmentedRow(icon: "globe", items: languages, selection: $languageField)

                        // Type picker (only if multiple types)
                        if config.agentTypes.count > 1 {
                            segmentedRow(
                                icon: "sparkles",
                                items: config.agentTypes.map(\.id),
                                labels: Dictionary(uniqueKeysWithValues: config.agentTypes.map { ($0.id, $0.displayName) }),
                                selection: $typeField
                            )
                        }
                    }
                    .padding(.horizontal, 32)

                    Button(action: startSession) {
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                            Text("Start Conversation")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(colors: theme.titleGradient, startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 4)

                    Text(activeConfig.footerText)
                        .font(.system(size: 12, weight: .light))
                        .tracking(0.3)
                        .foregroundColor(theme.dimmedTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 4)

                    Spacer().frame(height: 0)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: geo.size.height)
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    // MARK: - Session View

    private var sessionView: some View {
        VStack(spacing: 0) {
            // Top: title + subtitle + tagline
            VStack(spacing: 6) {
                Text(activeConfig.title)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .tracking(-0.5)
                    .foregroundStyle(
                        LinearGradient(colors: theme.titleGradient, startPoint: .leading, endPoint: .trailing)
                    )
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 12)
                    .animation(.easeOut(duration: 0.8), value: showTitle)

                Text(activeConfig.subtitle)
                    .font(.system(size: 13, weight: .light))
                    .tracking(0.3)
                    .foregroundColor(theme.subtleTextColor)
                    .opacity(showSubtitle ? 1 : 0)
                    .offset(y: showSubtitle ? 0 : 12)
                    .animation(.easeOut(duration: 0.8), value: showSubtitle)

                TypewriterText(phrases: activeConfig.taglines, cursorColor: theme.accentColor.opacity(0.5))
                    .opacity(showTagline ? 1 : 0)
                    .offset(y: showTagline ? 0 : 12)
                    .animation(.easeOut(duration: 0.8), value: showTagline)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 60)

            Spacer()

            VStack(spacing: 0) {
                OrbView(state: viewModel.state, audioLevel: viewModel.audioLevel, theme: theme)
                    .onTapGesture { handleTap() }
                    .frame(maxWidth: .infinity)
                    .scaleEffect(showOrb ? 1 : 0.92)
                    .opacity(showOrb ? 1 : 0)
                    .animation(.easeOut(duration: 0.8), value: showOrb)

                Spacer().frame(height: 28)

                Text(statusText)
                    .font(.system(size: 15, weight: .medium))
                    .tracking(0.5)
                    .foregroundColor(statusColor)
                    .animation(.easeInOut(duration: 0.4), value: viewModel.state)
                    .frame(maxWidth: .infinity)
                    .opacity(showStatus ? 1 : 0)
                    .offset(y: showStatus ? 0 : 12)
                    .animation(.easeOut(duration: 0.8), value: showStatus)

                if viewModel.state == .listening || viewModel.state == .speaking {
                    let m = viewModel.elapsedSeconds / 60
                    let s = viewModel.elapsedSeconds % 60
                    Text(String(format: "%02d:%02d", m, s))
                        .font(.system(size: 12, weight: .light).monospacedDigit())
                        .foregroundColor(theme.dimmedTextColor)
                        .padding(.top, 8)
                        .transition(.opacity)
                        .frame(maxWidth: .infinity)
                }
            }

            Spacer()

            // Footer
            VStack(spacing: 4) {
                if !nameField.isEmpty {
                    Text("Talking as \(nameField)")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(theme.subtleTextColor)
                }
                Text(activeConfig.footerText)
                    .font(.system(size: 12, weight: .light))
                    .tracking(0.3)
                    .foregroundColor(theme.dimmedTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
            .opacity(showFooter ? 1 : 0)
            .offset(y: showFooter ? 0 : 12)
            .animation(.easeOut(duration: 0.8), value: showFooter)
        }
        .onAppear {
            showTitle = false; showSubtitle = false; showTagline = false
            showOrb = false; showStatus = false; showFooter = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { showTitle = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { showSubtitle = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { showOrb = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { showTagline = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { showStatus = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showFooter = true }
        }
    }

    // MARK: - Helpers

    private var statusText: String {
        switch viewModel.state {
        case .idle: return "Tap the orb to start talking"
        case .connecting: return "Connecting..."
        case .listening: return "Listening..."
        case .speaking: return "Speaking..."
        case .disconnected: return "Tap to reconnect"
        }
    }

    private var statusColor: Color {
        switch viewModel.state {
        case .speaking: return theme.speakingAccentColor
        case .listening: return theme.accentColor
        case .connecting: return Color.white.opacity(0.4)
        default: return theme.subtleTextColor
        }
    }

    private func startSession() {
        viewModel.userInfo = UserInfo(
            name: nameField,
            subject: subjectField,
            language: languageField,
            type: typeField
        )
        showForm = false
        if !hasPermission { requestMicPermission() } else { viewModel.toggle() }
    }

    private func handleTap() {
        if viewModel.state == .idle || viewModel.state == .disconnected {
            if !hasPermission { requestMicPermission() } else { viewModel.toggle() }
        } else {
            viewModel.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if viewModel.state == .idle { showForm = true }
            }
        }
    }

    private func checkMicPermission() {
        hasPermission = AVAudioSession.sharedInstance().recordPermission == .granted
    }

    private func requestMicPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                hasPermission = granted
                if granted { viewModel.toggle() }
            }
        }
    }

    // MARK: - Reusable Form Components

    private let fieldBg = Color.white.opacity(0.06)
    private let fieldBorder = Color.white.opacity(0.1)

    private func formField(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(theme.accentColor)
                .frame(width: 20)
            TextField("", text: text, prompt: Text(placeholder).foregroundColor(theme.subtleTextColor))
                .foregroundColor(.white)
                .font(.system(size: 15))
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16).padding(.vertical, 14)
        .background(fieldBg).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(fieldBorder, lineWidth: 1))
    }

    private func segmentedRow(
        icon: String,
        items: [String],
        labels: [String: String]? = nil,
        selection: Binding<String>
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(theme.accentColor)
                .frame(width: 20)

            ForEach(items, id: \.self) { item in
                let isSelected = selection.wrappedValue == item
                let label = labels?[item] ?? item
                Text(label)
                    .font(.system(size: 13, weight: isSelected ? .medium : .light))
                    .foregroundColor(isSelected ? theme.accentColor : theme.subtleTextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(isSelected ? theme.accentColor.opacity(0.15) : Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? theme.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
                    .onTapGesture { selection.wrappedValue = item }
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
        .background(fieldBg).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(fieldBorder, lineWidth: 1))
    }
}
