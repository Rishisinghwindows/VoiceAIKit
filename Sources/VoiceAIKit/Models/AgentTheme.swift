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

// MARK: - Copying (override individual properties)

extension AgentTheme {
    /// Create a copy of this theme, overriding only the properties you pass.
    ///
    /// ```swift
    /// // Start from the default theme and just change background + accent:
    /// let myTheme = AgentTheme.default.copying(
    ///     backgroundColor: .black,
    ///     accentColor: .red
    /// )
    /// ```
    public func copying(
        backgroundColor: Color? = nil,
        titleGradient: [Color]? = nil,
        accentColor: Color? = nil,
        speakingAccentColor: Color? = nil,
        subtleTextColor: Color? = nil,
        dimmedTextColor: Color? = nil,
        idleBlobColors: [RGBA]? = nil,
        idleRingColors: [Color]? = nil,
        activeBlobColors: [RGBA]? = nil,
        activeRingColors: [Color]? = nil,
        idleGlowColor: RGBA? = nil,
        activeGlowColor: RGBA? = nil,
        orbDarkBase: Color? = nil,
        idleOrbBg: RGBA? = nil,
        activeOrbBg: RGBA? = nil
    ) -> AgentTheme {
        AgentTheme(
            backgroundColor: backgroundColor ?? self.backgroundColor,
            titleGradient: titleGradient ?? self.titleGradient,
            accentColor: accentColor ?? self.accentColor,
            speakingAccentColor: speakingAccentColor ?? self.speakingAccentColor,
            subtleTextColor: subtleTextColor ?? self.subtleTextColor,
            dimmedTextColor: dimmedTextColor ?? self.dimmedTextColor,
            idleBlobColors: idleBlobColors ?? self.idleBlobColors,
            idleRingColors: idleRingColors ?? self.idleRingColors,
            activeBlobColors: activeBlobColors ?? self.activeBlobColors,
            activeRingColors: activeRingColors ?? self.activeRingColors,
            idleGlowColor: idleGlowColor ?? self.idleGlowColor,
            activeGlowColor: activeGlowColor ?? self.activeGlowColor,
            orbDarkBase: orbDarkBase ?? self.orbDarkBase,
            idleOrbBg: idleOrbBg ?? self.idleOrbBg,
            activeOrbBg: activeOrbBg ?? self.activeOrbBg
        )
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

    /// Deep navy background with golden/amber accents — inspired by legal/law apps.
    public static let legal = AgentTheme(
        backgroundColor: Color(red: 0.067, green: 0.067, blue: 0.165),   // #111129 deep navy
        titleGradient: [
            Color(red: 0.886, green: 0.718, blue: 0.220),  // golden yellow
            Color(red: 0.957, green: 0.804, blue: 0.298),  // bright amber
        ],
        accentColor: Color(red: 0.886, green: 0.718, blue: 0.220),       // gold
        speakingAccentColor: Color(red: 0.957, green: 0.804, blue: 0.298), // bright gold
        subtleTextColor: Color.white.opacity(0.35),
        dimmedTextColor: Color.white.opacity(0.15),
        idleBlobColors: [
            RGBA(r: 0.886, g: 0.718, b: 0.220, a: 0.90),  // gold
            RGBA(r: 0.400, g: 0.310, b: 0.700, a: 0.80),  // indigo accent
            RGBA(r: 0.957, g: 0.804, b: 0.298, a: 0.70),  // amber
            RGBA(r: 0.310, g: 0.270, b: 0.580, a: 0.65),  // deep purple
            RGBA(r: 0.886, g: 0.718, b: 0.220, a: 0.55),  // gold
            RGBA(r: 0.480, g: 0.380, b: 0.750, a: 0.60),  // purple
            RGBA(r: 0.820, g: 0.650, b: 0.180, a: 0.50),  // dark gold
        ],
        idleRingColors: [
            Color(red: 0.886, green: 0.718, blue: 0.220),
            Color(red: 0.400, green: 0.310, blue: 0.700),
            Color(red: 0.957, green: 0.804, blue: 0.298),
            Color(red: 0.310, green: 0.270, blue: 0.580),
            Color(red: 0.886, green: 0.718, blue: 0.220),
            Color(red: 0.480, green: 0.380, blue: 0.750),
        ],
        activeBlobColors: [
            RGBA(r: 0.957, g: 0.804, b: 0.298, a: 0.90),  // bright gold
            RGBA(r: 0.886, g: 0.718, b: 0.220, a: 0.80),  // gold
            RGBA(r: 0.980, g: 0.850, b: 0.400, a: 0.70),  // light gold
            RGBA(r: 0.500, g: 0.400, b: 0.780, a: 0.65),  // purple flash
            RGBA(r: 0.957, g: 0.804, b: 0.298, a: 0.55),  // amber
            RGBA(r: 0.920, g: 0.760, b: 0.260, a: 0.60),  // warm gold
            RGBA(r: 0.980, g: 0.870, b: 0.420, a: 0.50),  // pale gold
        ],
        activeRingColors: [
            Color(red: 0.957, green: 0.804, blue: 0.298),
            Color(red: 0.886, green: 0.718, blue: 0.220),
            Color(red: 0.980, green: 0.850, blue: 0.400),
            Color(red: 0.500, green: 0.400, blue: 0.780),
            Color(red: 0.957, green: 0.804, blue: 0.298),
            Color(red: 0.920, green: 0.760, blue: 0.260),
        ],
        idleGlowColor: RGBA(r: 0.886, g: 0.718, b: 0.220, a: 0.25),
        activeGlowColor: RGBA(r: 0.957, g: 0.804, b: 0.298, a: 0.28),
        orbDarkBase: Color(red: 0.04, green: 0.04, blue: 0.10),
        idleOrbBg: RGBA(r: 0.08, g: 0.07, b: 0.18, a: 1),
        activeOrbBg: RGBA(r: 0.10, g: 0.09, b: 0.06, a: 1)
    )
}
