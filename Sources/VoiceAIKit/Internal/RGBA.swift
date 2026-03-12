import SwiftUI

/// A simple RGBA color representation for smooth interpolation.
public struct RGBA: Sendable {
    public let r: Float, g: Float, b: Float, a: Float

    public init(r: Float, g: Float, b: Float, a: Float) {
        self.r = r; self.g = g; self.b = b; self.a = a
    }

    public func lerp(to other: RGBA, t: Float) -> RGBA {
        RGBA(
            r: r + (other.r - r) * t,
            g: g + (other.g - g) * t,
            b: b + (other.b - b) * t,
            a: a + (other.a - a) * t
        )
    }

    public var color: Color {
        Color(.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}
