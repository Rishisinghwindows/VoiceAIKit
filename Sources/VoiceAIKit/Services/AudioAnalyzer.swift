import AVFoundation
import LiveKit

/// Analyzes audio levels from LiveKit audio tracks in real time.
public class AudioAnalyzer: @unchecked Sendable, AudioRenderer {
    private let lock = NSLock()
    private var _level: Float = 0
    private var smoothedLevel: Float = 0
    private let lerpFactor: Float = 0.15
    private var attachedTrack: (any AudioTrackProtocol)?

    public init() {}

    /// The current smoothed audio level (0.0 – 1.0).
    public var level: Float {
        lock.lock()
        defer { lock.unlock() }
        return _level
    }

    /// Attach the analyzer to a LiveKit audio track.
    public func attachToTrack(_ track: any AudioTrackProtocol) {
        detach()
        track.add(audioRenderer: self)
        lock.lock()
        attachedTrack = track
        lock.unlock()
    }

    /// Detach from the current track and reset levels.
    public func detach() {
        lock.lock()
        let track = attachedTrack
        attachedTrack = nil
        smoothedLevel = 0
        _level = 0
        lock.unlock()
        track?.remove(audioRenderer: self)
    }

    public func render(pcmBuffer: AVAudioPCMBuffer) {
        let rms = calculateRms(buffer: pcmBuffer)
        lock.lock()
        smoothedLevel += (rms - smoothedLevel) * lerpFactor
        _level = smoothedLevel
        lock.unlock()
    }

    private func calculateRms(buffer: AVAudioPCMBuffer) -> Float {
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return 0 }

        var sumSquares: Float = 0

        if let channelData = buffer.floatChannelData {
            let samples = channelData[0]
            for i in 0..<frameLength { let s = samples[i]; sumSquares += s * s }
        } else if let channelData = buffer.int16ChannelData {
            let samples = channelData[0]
            for i in 0..<frameLength { let s = Float(samples[i]) / Float(Int16.max); sumSquares += s * s }
        } else if let channelData = buffer.int32ChannelData {
            let samples = channelData[0]
            for i in 0..<frameLength { let s = Float(samples[i]) / Float(Int32.max); sumSquares += s * s }
        } else {
            return 0
        }

        return min(sqrt(sumSquares / Float(frameLength)) * 4.0, 1.0)
    }
}
