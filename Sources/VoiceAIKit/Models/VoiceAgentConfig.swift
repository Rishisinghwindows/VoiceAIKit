import SwiftUI

/// Configuration for a voice agent type (e.g., MentalHealth, legalAdviser, FinanceGuru).
public struct AgentTypeConfig: Sendable {
    public let id: String
    public let displayName: String
    public let title: String
    public let subtitle: String
    public let footerText: String
    public let subjectPlaceholder: String
    public let taglines: [String]
    public let theme: AgentTheme

    public init(
        id: String,
        displayName: String,
        title: String,
        subtitle: String,
        footerText: String,
        subjectPlaceholder: String,
        taglines: [String],
        theme: AgentTheme
    ) {
        self.id = id
        self.displayName = displayName
        self.title = title
        self.subtitle = subtitle
        self.footerText = footerText
        self.subjectPlaceholder = subjectPlaceholder
        self.taglines = taglines
        self.theme = theme
    }
}

/// Top-level configuration for VoiceAIKit.
public struct VoiceAgentConfig {
    /// The base URL for fetching LiveKit tokens (e.g., "https://advancedvoiceagent.xappy.io").
    public let serverURL: String

    /// The LiveKit WebSocket URL (e.g., "wss://apiadvancedvoiceagent.xappy.io").
    public let livekitURL: String

    /// Available agent types the user can pick from.
    public let agentTypes: [AgentTypeConfig]

    /// Default agent type ID.
    public let defaultAgentType: String

    /// Maximum retry attempts for connection.
    public let maxRetries: Int

    public init(
        serverURL: String,
        livekitURL: String,
        agentTypes: [AgentTypeConfig],
        defaultAgentType: String = "",
        maxRetries: Int = 3
    ) {
        self.serverURL = serverURL
        self.livekitURL = livekitURL
        self.agentTypes = agentTypes
        self.defaultAgentType = defaultAgentType.isEmpty
            ? (agentTypes.first?.id ?? "")
            : defaultAgentType
        self.maxRetries = maxRetries
    }
}

// MARK: - Copying (override individual properties)

extension AgentTypeConfig {
    /// Create a copy of this agent type config, overriding only the properties you pass.
    ///
    /// ```swift
    /// // Start from the built-in legal config and customize:
    /// let myAgent = AgentTypeConfig.legalAdviser.copying(
    ///     title: "My Legal Bot",
    ///     taglines: ["Ask me anything about law"],
    ///     theme: .legal.copying(backgroundColor: .black)
    /// )
    /// ```
    public func copying(
        id: String? = nil,
        displayName: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        footerText: String? = nil,
        subjectPlaceholder: String? = nil,
        taglines: [String]? = nil,
        theme: AgentTheme? = nil
    ) -> AgentTypeConfig {
        AgentTypeConfig(
            id: id ?? self.id,
            displayName: displayName ?? self.displayName,
            title: title ?? self.title,
            subtitle: subtitle ?? self.subtitle,
            footerText: footerText ?? self.footerText,
            subjectPlaceholder: subjectPlaceholder ?? self.subjectPlaceholder,
            taglines: taglines ?? self.taglines,
            theme: theme ?? self.theme
        )
    }
}

// MARK: - Built-in Agent Type Configs

extension AgentTypeConfig {
    public static let mentalHealth = AgentTypeConfig(
        id: "MentalHealth",
        displayName: "Mental Health",
        title: "Voice AI Assistant",
        subtitle: "Talk in Hindi or English \u{2014} powered by real-time AI",
        footerText: "Ask anything \u{2014} available 24/7 in English and Hindi",
        subjectPlaceholder: "Mental health topic to discuss",
        taglines: [
            "I'm Maya, your mental health companion",
            "Share how you feel, I'm here to listen",
            "Breathing exercises & coping tips available",
        ],
        theme: .default
    )

    public static let legalAdviser = AgentTypeConfig(
        id: "legalAdviser",
        displayName: "Legal",
        title: "AI Legal Guru",
        subtitle: "Your AI guide to Indian law",
        footerText: "Ask about BNS, IPC, Constitution & more \u{2014} 24/7",
        subjectPlaceholder: "Legal topic to discuss",
        taglines: [
            "Ask about IPC, BNS & Indian Constitution",
            "Get instant answers on legal sections",
            "Understand your rights under Indian law",
        ],
        theme: .legal
    )

    public static let financeGuru = AgentTypeConfig(
        id: "FinanceGuru",
        displayName: "Finance",
        title: "Finance Guru",
        subtitle: "Your AI-powered financial advisor",
        footerText: "Investment, tax & financial planning \u{2014} 24/7",
        subjectPlaceholder: "Financial topic to discuss",
        taglines: [
            "Ask about investments & portfolio planning",
            "Get answers on tax savings & mutual funds",
            "Understand your financial options",
        ],
        theme: .default
    )
}

// MARK: - Default Config

extension VoiceAgentConfig {
    /// A default configuration using the UBudy server with all built-in agent types.
    public static let `default` = VoiceAgentConfig(
        serverURL: "https://advancedvoiceagent.xappy.io",
        livekitURL: "wss://apiadvancedvoiceagent.xappy.io",
        agentTypes: [.mentalHealth, .legalAdviser, .financeGuru],
        defaultAgentType: "MentalHealth"
    )
}
