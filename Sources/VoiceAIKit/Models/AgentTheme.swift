import SwiftUI

/// Defines the visual theme for the voice agent UI.
public struct AgentTheme: Sendable {
    public let backgroundColor: Color
    public let titleGradient: [Color]
    public let accentColor: Color
    public let speakingAccentColor: Color
    public let subtleTextColor: Color
    public let dimmedTextColor: Color

    // Orb colors (idle state)
    public let idleBlobColors: [RGBA]
    public let idleRingColors: [Color]

    // Orb colors (speaking state)
    public let activeBlobColors: [RGBA]
    public let activeRingColors: [Color]

    // Orb glow
    public let idleGlowColor: RGBA
    public let activeGlowColor: RGBA

    // Orb body
    public let orbDarkBase: Color
    public let idleOrbBg: RGBA
    public let activeOrbBg: RGBA

    public init(
        backgroundColor: Color,
        titleGradient: [Color],
        accentColor: Color,
        speakingAccentColor: Color,
        subtleTextColor: Color = .white.opacity(0.25),
        dimmedTextColor: Color = .white.opacity(0.1),
        idleBlobColors: [RGBA],
        idleRingColors: [Color],
        activeBlobColors: [RGBA],
        activeRingColors: [Color],
        idleGlowColor: RGBA,
        activeGlowColor: RGBA,
        orbDarkBase: Color,
        idleOrbBg: RGBA,
        activeOrbBg: RGBA
    ) {
        self.backgroundColor = backgroundColor
        self.titleGradient = titleGradient
        self.accentColor = accentColor
        self.speakingAccentColor = speakingAccentColor
        self.subtleTextColor = subtleTextColor
        self.dimmedTextColor = dimmedTextColor
        self.idleBlobColors = idleBlobColors
        self.idleRingColors = idleRingColors
        self.activeBlobColors = activeBlobColors
        self.activeRingColors = activeRingColors
        self.idleGlowColor = idleGlowColor
        self.activeGlowColor = activeGlowColor
        self.orbDarkBase = orbDarkBase
        self.idleOrbBg = idleOrbBg
        self.activeOrbBg = activeOrbBg
    }
}

// MARK: - Built-in Themes

extension AgentTheme {

    /// Default purple/teal theme for mental health companion.
    public static let `default` = AgentTheme(
        backgroundColor: Color(red: 0x0A/255.0, green: 0x0A/255.0, blue: 0x0F/255.0),
        titleGradient: [
            Color(red: 0.655, green: 0.545, blue: 0.980),
            Color(red: 0.388, green: 0.400, blue: 0.945),
        ],
        accentColor: Color(red: 0.655, green: 0.545, blue: 0.980).opacity(0.8),
        speakingAccentColor: Color(red: 0.078, green: 0.945, blue: 0.584).opacity(0.8),
        idleBlobColors: [
            RGBA(r: 0.545, g: 0.361, b: 0.965, a: 0.90),
            RGBA(r: 0.388, g: 0.400, b: 0.945, a: 0.80),
            RGBA(r: 0.231, g: 0.510, b: 0.965, a: 0.70),
            RGBA(r: 0.024, g: 0.714, b: 0.831, a: 0.65),
            RGBA(r: 0.655, g: 0.545, b: 0.980, a: 0.55),
            RGBA(r: 0.400, g: 0.300, b: 0.900, a: 0.60),
            RGBA(r: 0.500, g: 0.400, b: 0.950, a: 0.50),
        ],
        idleRingColors: [
            Color(red: 0.545, green: 0.361, blue: 0.965),
            Color(red: 0.388, green: 0.400, blue: 0.945),
            Color(red: 0.231, green: 0.510, blue: 0.965),
            Color(red: 0.024, green: 0.714, blue: 0.831),
            Color(red: 0.655, green: 0.545, blue: 0.980),
            Color(red: 0.545, green: 0.361, blue: 0.965),
        ],
        activeBlobColors: [
            RGBA(r: 0.078, g: 0.945, b: 0.584, a: 0.90),
            RGBA(r: 0.024, g: 0.714, b: 0.831, a: 0.80),
            RGBA(r: 0.204, g: 0.827, b: 0.600, a: 0.70),
            RGBA(r: 0.133, g: 0.827, b: 0.933, a: 0.65),
            RGBA(r: 0.078, g: 0.945, b: 0.584, a: 0.55),
            RGBA(r: 0.050, g: 0.800, b: 0.700, a: 0.60),
            RGBA(r: 0.100, g: 0.900, b: 0.500, a: 0.50),
        ],
        activeRingColors: [
            Color(red: 0.078, green: 0.945, blue: 0.584),
            Color(red: 0.024, green: 0.714, blue: 0.831),
            Color(red: 0.231, green: 0.510, blue: 0.965),
            Color(red: 0.133, green: 0.827, blue: 0.933),
            Color(red: 0.063, green: 0.725, blue: 0.506),
            Color(red: 0.078, green: 0.945, blue: 0.584),
        ],
        idleGlowColor: RGBA(r: 0.545, g: 0.361, b: 0.965, a: 0.22),
        activeGlowColor: RGBA(r: 0.078, g: 0.945, b: 0.584, a: 0.22),
        orbDarkBase: Color(red: 0.03, green: 0.03, blue: 0.07),
        idleOrbBg: RGBA(r: 0.12, g: 0.07, b: 0.27, a: 1),
        activeOrbBg: RGBA(r: 0.04, g: 0.12, b: 0.10, a: 1)
    )

    /// Amber/gold theme for legal adviser.
    public static let legal = AgentTheme(
        backgroundColor: Color(red: 0.102, green: 0.071, blue: 0.039),
        titleGradient: [
            Color(red: 0.831, green: 0.533, blue: 0.039),
            Color(red: 0.855, green: 0.667, blue: 0.125),
        ],
        accentColor: Color(red: 0.855, green: 0.667, blue: 0.125),
        speakingAccentColor: Color(red: 0.961, green: 0.784, blue: 0.314),
        idleBlobColors: [
            RGBA(r: 0.824, g: 0.549, b: 0.157, a: 0.90),
            RGBA(r: 0.784, g: 0.510, b: 0.137, a: 0.80),
            RGBA(r: 0.855, g: 0.627, b: 0.196, a: 0.70),
            RGBA(r: 0.745, g: 0.471, b: 0.118, a: 0.65),
            RGBA(r: 0.906, g: 0.690, b: 0.275, a: 0.55),
            RGBA(r: 0.780, g: 0.490, b: 0.120, a: 0.60),
            RGBA(r: 0.860, g: 0.600, b: 0.200, a: 0.50),
        ],
        idleRingColors: [
            Color(red: 0.831, green: 0.533, blue: 0.039),
            Color(red: 0.784, green: 0.439, blue: 0.125),
            Color(red: 0.910, green: 0.627, blue: 0.125),
            Color(red: 0.722, green: 0.525, blue: 0.043),
            Color(red: 0.855, green: 0.667, blue: 0.125),
            Color(red: 0.831, green: 0.533, blue: 0.039),
        ],
        activeBlobColors: [
            RGBA(r: 0.961, g: 0.784, b: 0.314, a: 0.90),
            RGBA(r: 0.855, g: 0.667, b: 0.125, a: 0.80),
            RGBA(r: 0.941, g: 0.753, b: 0.235, a: 0.70),
            RGBA(r: 0.784, g: 0.627, b: 0.157, a: 0.65),
            RGBA(r: 0.961, g: 0.816, b: 0.376, a: 0.55),
            RGBA(r: 0.880, g: 0.700, b: 0.200, a: 0.60),
            RGBA(r: 0.940, g: 0.780, b: 0.280, a: 0.50),
        ],
        activeRingColors: [
            Color(red: 0.961, green: 0.784, blue: 0.314),
            Color(red: 0.855, green: 0.667, blue: 0.125),
            Color(red: 0.910, green: 0.722, blue: 0.188),
            Color(red: 0.784, green: 0.627, blue: 0.125),
            Color(red: 0.941, green: 0.816, blue: 0.376),
            Color(red: 0.961, green: 0.784, blue: 0.314),
        ],
        idleGlowColor: RGBA(r: 0.824, g: 0.549, b: 0.157, a: 0.22),
        activeGlowColor: RGBA(r: 0.961, g: 0.784, b: 0.314, a: 0.22),
        orbDarkBase: Color(red: 0.05, green: 0.03, blue: 0.02),
        idleOrbBg: RGBA(r: 0.10, g: 0.06, b: 0.03, a: 1),
        activeOrbBg: RGBA(r: 0.10, g: 0.08, b: 0.03, a: 1)
    )
}
