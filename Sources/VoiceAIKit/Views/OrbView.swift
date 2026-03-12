import SwiftUI

// MARK: - Blob Config

private struct BlobConfig {
    let xFreq: Float, xPhase: Float
    let yFreq: Float, yPhase: Float
    let xAmp: Float, yAmp: Float
    let size: Float
    let x2Freq: Float, y2Freq: Float
    let x2Amp: Float, y2Amp: Float
}

private let blobs: [BlobConfig] = [
    BlobConfig(xFreq: 0.35, xPhase: 0.0, yFreq: 0.28, yPhase: 0.5, xAmp: 55, yAmp: 45, size: 0.82,
               x2Freq: 0.13, y2Freq: 0.17, x2Amp: 20, y2Amp: 15),
    BlobConfig(xFreq: 0.25, xPhase: 1.5, yFreq: 0.32, yPhase: 2.0, xAmp: 50, yAmp: 50, size: 0.72,
               x2Freq: 0.11, y2Freq: 0.19, x2Amp: 18, y2Amp: 22),
    BlobConfig(xFreq: 0.30, xPhase: 3.0, yFreq: 0.22, yPhase: 3.5, xAmp: 40, yAmp: 40, size: 0.65,
               x2Freq: 0.15, y2Freq: 0.12, x2Amp: 15, y2Amp: 18),
    BlobConfig(xFreq: 0.20, xPhase: 4.5, yFreq: 0.35, yPhase: 5.0, xAmp: 45, yAmp: 35, size: 0.55,
               x2Freq: 0.18, y2Freq: 0.14, x2Amp: 12, y2Amp: 20),
    BlobConfig(xFreq: 0.28, xPhase: 5.5, yFreq: 0.25, yPhase: 6.2, xAmp: 35, yAmp: 45, size: 0.45,
               x2Freq: 0.16, y2Freq: 0.21, x2Amp: 16, y2Amp: 14),
    BlobConfig(xFreq: 0.22, xPhase: 2.2, yFreq: 0.30, yPhase: 1.1, xAmp: 48, yAmp: 38, size: 0.60,
               x2Freq: 0.14, y2Freq: 0.16, x2Amp: 14, y2Amp: 16),
    BlobConfig(xFreq: 0.33, xPhase: 4.0, yFreq: 0.18, yPhase: 4.8, xAmp: 30, yAmp: 50, size: 0.50,
               x2Freq: 0.20, y2Freq: 0.10, x2Amp: 10, y2Amp: 12),
]

// MARK: - OrbView

/// An animated orb visualization that reacts to audio levels and connection state.
public struct OrbView: View {
    public let state: ConnectionState
    public let audioLevel: Float
    public let theme: AgentTheme

    @State private var startDate = Date()
    @State private var colorT: Float = 0
    @State private var smoothAudio: Float = 0
    @State private var targetColorT: Float = 0

    public init(state: ConnectionState, audioLevel: Float, theme: AgentTheme = .default) {
        self.state = state
        self.audioLevel = audioLevel
        self.theme = theme
    }

    public var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = Float(timeline.date.timeIntervalSince(startDate))

            Canvas { context, size in
                let dt: Float = 1.0 / 60.0
                let currentColorT = lerpValue(colorT, towards: targetColorT, speed: 2.5 * dt)
                let currentAudio = lerpValue(smoothAudio, towards: audioLevel, speed: 12.0 * dt)

                drawOrb(
                    context: &context, size: size,
                    elapsed: elapsed, colorT: currentColorT,
                    audio: currentAudio, state: state
                )

                DispatchQueue.main.async {
                    self.colorT = currentColorT
                    self.smoothAudio = currentAudio
                }
            }
        }
        .frame(width: 320, height: 320)
        .onChange(of: state) { newState in
            targetColorT = (newState == .speaking) ? 1.0 : 0.0
        }
    }

    private func lerpValue(_ current: Float, towards target: Float, speed: Float) -> Float {
        current + (target - current) * min(speed, 1.0)
    }

    // MARK: - Draw

    private func drawOrb(
        context: inout GraphicsContext, size: CGSize,
        elapsed: Float, colorT: Float, audio: Float, state: ConnectionState
    ) {
        let cx = size.width / 2, cy = size.height / 2
        let baseRadius = size.width * 0.34
        let isActive = state != .idle && state != .disconnected
        let isConnecting = state == .connecting
        let isSpeaking = state == .speaking

        let speed: Float = isConnecting ? 2.8 : (isSpeaking ? 1.6 + audio * 2.0 : 1.0)
        let t = elapsed * speed
        let breath = 1.0 + 0.012 * sin(elapsed * 1.8) + 0.008 * sin(elapsed * 2.7)
        let audioScale = 1.0 + CGFloat(audio) * 0.08
        let orbRadius = baseRadius * CGFloat(breath) * audioScale
        let center = CGPoint(x: cx, y: cy)

        let glowPulse = Float(0.7 + 0.3 * (0.5 + 0.5 * sin(Double(elapsed) * 1.2)))
        let glowIntensity = CGFloat(glowPulse) * (isActive ? 1.0 : 0.3)

        // LAYER 1: Deep ambient glow
        let deepIdle = RGBA(r: theme.idleGlowColor.r, g: theme.idleGlowColor.g, b: theme.idleGlowColor.b, a: 0.12)
        let deepActive = RGBA(r: theme.activeGlowColor.r, g: theme.activeGlowColor.g, b: theme.activeGlowColor.b, a: 0.12)
        let deepGlow = deepIdle.lerp(to: deepActive, t: colorT)
        let deepRadius = orbRadius * 2.8
        var g1 = context; g1.opacity = glowIntensity * 0.8
        g1.fill(circle(center, deepRadius), with: .radialGradient(
            Gradient(colors: [deepGlow.color, deepGlow.color.opacity(0.3), .clear]),
            center: center, startRadius: 0, endRadius: deepRadius
        ))

        // LAYER 2: Mid glow
        let midGlow = theme.idleGlowColor.lerp(to: theme.activeGlowColor, t: colorT)
        let midRadius = orbRadius * 1.8
        var g2 = context; g2.opacity = glowIntensity
        g2.fill(circle(center, midRadius), with: .radialGradient(
            Gradient(colors: [midGlow.color, midGlow.color.opacity(0.4), .clear]),
            center: center, startRadius: orbRadius * 0.3, endRadius: midRadius
        ))

        // LAYER 3: Inner glow halo
        let innerIdle = RGBA(r: theme.idleGlowColor.r, g: theme.idleGlowColor.g, b: theme.idleGlowColor.b, a: 0.35)
        let innerActive = RGBA(r: theme.activeGlowColor.r, g: theme.activeGlowColor.g, b: theme.activeGlowColor.b, a: 0.35)
        let innerGlow = innerIdle.lerp(to: innerActive, t: colorT)
        let innerRadius = orbRadius * 1.35
        var g3 = context; g3.opacity = glowIntensity * 1.2
        g3.fill(circle(center, innerRadius), with: .radialGradient(
            Gradient(colors: [innerGlow.color, .clear]),
            center: center, startRadius: orbRadius * 0.7, endRadius: innerRadius
        ))

        // LAYER 4: Rotating ring
        let ringAngle = fmod(Double(elapsed) * 55.0, 360.0)
        let ringColors = colorT > 0.5 ? theme.activeRingColors : theme.idleRingColors
        let ringPulse = 0.5 + 0.15 * sin(Double(elapsed) * 2.0) + Double(audio) * 0.35
        var r1 = context; r1.opacity = 0.25 * Double(glowIntensity)
        r1.fill(circle(center, orbRadius * 1.18), with: .conicGradient(
            Gradient(colors: ringColors), center: center, angle: .degrees(ringAngle)
        ))
        var r2 = context; r2.opacity = ringPulse * Double(glowIntensity)
        r2.fill(circle(center, orbRadius * 1.06), with: .conicGradient(
            Gradient(colors: ringColors), center: center, angle: .degrees(ringAngle + 180)
        ))

        // LAYER 5: Orb body
        context.fill(circle(center, orbRadius), with: .color(theme.orbDarkBase))
        let bgA = theme.idleOrbBg.lerp(to: theme.activeOrbBg, t: colorT)
        context.fill(circle(center, orbRadius), with: .radialGradient(
            Gradient(colors: [bgA.color, theme.orbDarkBase]),
            center: CGPoint(x: cx * 0.92, y: cy * 0.85), startRadius: 0, endRadius: orbRadius
        ))

        // LAYER 6: Organic blobs
        let idleBlobs = theme.idleBlobColors
        let activeBlobs = theme.activeBlobColors
        for i in blobs.indices {
            let b = blobs[i]
            let blobRadius = orbRadius * CGFloat(b.size) * (1.0 + CGFloat(audio) * 0.25)
            let px = CGFloat(sin(t * b.xFreq + b.xPhase) * b.xAmp + sin(t * b.x2Freq + b.xPhase * 2.1) * b.x2Amp)
            let py = CGFloat(cos(t * b.yFreq + b.yPhase) * b.yAmp + cos(t * b.y2Freq + b.yPhase * 1.7) * b.y2Amp)
            let blobCenter = CGPoint(x: cx + px * orbRadius / 150.0, y: cy + py * orbRadius / 150.0)
            let blobColor = idleBlobs[i].lerp(to: activeBlobs[i], t: colorT)
            var bc = context; bc.blendMode = .screen
            bc.fill(circle(blobCenter, blobRadius), with: .radialGradient(
                Gradient(stops: [
                    .init(color: blobColor.color, location: 0),
                    .init(color: blobColor.color.opacity(0.6), location: 0.4),
                    .init(color: blobColor.color.opacity(0.15), location: 0.75),
                    .init(color: .clear, location: 1.0),
                ]),
                center: blobCenter, startRadius: 0, endRadius: blobRadius
            ))
        }

        // LAYER 7: Audio-reactive energy waves
        if audio > 0.02 && isActive {
            for w in 0..<3 {
                let wPhase = Float(w) * 2.1 + elapsed * 3.0
                let wRadius = orbRadius * (0.5 + CGFloat(audio) * 0.6 + CGFloat(sin(wPhase)) * 0.15)
                let wAlpha = Float(audio) * 0.35 * (1.0 - Float(w) * 0.25)
                let waveBase = RGBA(r: theme.idleGlowColor.r, g: theme.idleGlowColor.g, b: theme.idleGlowColor.b, a: wAlpha)
                let waveTgt = RGBA(r: theme.activeGlowColor.r, g: theme.activeGlowColor.g, b: theme.activeGlowColor.b, a: wAlpha)
                let waveColor = waveBase.lerp(to: waveTgt, t: colorT)
                var wc = context; wc.blendMode = .screen
                wc.fill(circle(center, wRadius), with: .radialGradient(
                    Gradient(colors: [waveColor.color, waveColor.color.opacity(0.3), .clear]),
                    center: center, startRadius: wRadius * 0.6, endRadius: wRadius
                ))
            }
        }

        // LAYER 8: Glass highlight
        context.fill(circle(center, orbRadius), with: .radialGradient(
            Gradient(stops: [
                .init(color: Color.white.opacity(0.30), location: 0),
                .init(color: Color.white.opacity(0.08), location: 0.35),
                .init(color: .clear, location: 0.7),
            ]),
            center: CGPoint(x: cx * 0.78, y: cy * 0.68), startRadius: 0, endRadius: orbRadius * 0.65
        ))
        context.fill(circle(center, orbRadius), with: .radialGradient(
            Gradient(colors: [Color.white.opacity(0.06), .clear]),
            center: CGPoint(x: cx * 1.15, y: cy * 1.25), startRadius: 0, endRadius: orbRadius * 0.4
        ))

        // LAYER 9: Edge vignette
        context.fill(circle(center, orbRadius), with: .radialGradient(
            Gradient(stops: [
                .init(color: .clear, location: 0.5),
                .init(color: Color.black.opacity(0.25), location: 0.85),
                .init(color: Color.black.opacity(0.55), location: 1.0),
            ]),
            center: center, startRadius: 0, endRadius: orbRadius
        ))

        // LAYER 10: Rim light
        let rimIdle = RGBA(r: theme.idleGlowColor.r, g: theme.idleGlowColor.g, b: theme.idleGlowColor.b, a: 0.30)
        let rimActive = RGBA(r: theme.activeGlowColor.r, g: theme.activeGlowColor.g, b: theme.activeGlowColor.b, a: 0.30)
        let rimColor = rimIdle.lerp(to: rimActive, t: colorT)
        var rc = context; rc.opacity = 0.4 + Double(audio) * 0.5
        rc.fill(circle(center, orbRadius * 1.25), with: .radialGradient(
            Gradient(colors: [.clear, rimColor.color, .clear]),
            center: center, startRadius: orbRadius * 0.9, endRadius: orbRadius * 1.25
        ))

        // LAYER 11: Floating particles
        if isActive {
            for p in 0..<12 {
                let fp = Float(p)
                let angle = fp * (2.0 * .pi / 12.0) + elapsed * (0.15 + fp * 0.02)
                let dist = orbRadius * (1.15 + CGFloat(sin(elapsed * 0.8 + fp * 0.7)) * 0.2) + CGFloat(audio) * orbRadius * 0.15
                let pSize: CGFloat = 1.5 + CGFloat(sin(elapsed * 1.5 + fp * 1.3)) * 1.0 + CGFloat(audio) * 3.0
                let pAlpha = Float(0.15 + 0.15 * sin(Double(elapsed) * 2.0 + Double(fp) * 0.9) + Double(audio) * 0.3)
                let pIdle = RGBA(r: theme.idleGlowColor.r, g: theme.idleGlowColor.g, b: theme.idleGlowColor.b, a: pAlpha)
                let pActive = RGBA(r: theme.activeGlowColor.r, g: theme.activeGlowColor.g, b: theme.activeGlowColor.b, a: pAlpha)
                let pColor = pIdle.lerp(to: pActive, t: colorT)
                let particleCenter = CGPoint(x: cx + cos(CGFloat(angle)) * dist, y: cy + sin(CGFloat(angle)) * dist)
                var pc = context; pc.blendMode = .screen
                pc.fill(circle(particleCenter, pSize * 3), with: .radialGradient(
                    Gradient(colors: [pColor.color, .clear]),
                    center: particleCenter, startRadius: 0, endRadius: pSize * 3
                ))
            }
        }

        // LAYER 12: Connecting spinner
        if isConnecting {
            for d in 0..<8 {
                let fd = Float(d)
                let angle = fd * (2.0 * .pi / 8.0) + elapsed * 4.0
                let dist = orbRadius * 1.22
                let dotAlpha = 0.3 + 0.4 * (0.5 + 0.5 * sin(Double(angle) - Double(elapsed) * 6.0))
                let dotCenter = CGPoint(x: cx + cos(CGFloat(angle)) * dist, y: cy + sin(CGFloat(angle)) * dist)
                var dc = context; dc.opacity = dotAlpha
                dc.fill(circle(dotCenter, 3), with: .radialGradient(
                    Gradient(colors: [theme.accentColor, .clear]),
                    center: dotCenter, startRadius: 0, endRadius: 3
                ))
            }
        }
    }

    private func circle(_ center: CGPoint, _ radius: CGFloat) -> Path {
        Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
    }
}
