import Foundation
import LiveKit
import Combine

/// Manages the LiveKit connection and audio state for the voice agent.
@MainActor
public class VoiceAgentViewModel: ObservableObject {
    @Published public var state: ConnectionState = .idle
    @Published public var audioLevel: Float = 0
    @Published public var elapsedSeconds: Int = 0

    public var userInfo = UserInfo()

    private let config: VoiceAgentConfig
    private var room: Room?
    private let agentAudioAnalyzer = AudioAnalyzer()
    private var timerTask: Task<Void, Never>?
    private var audioLevelTask: Task<Void, Never>?
    private var speakingHoldFrames = 0

    public init(config: VoiceAgentConfig = .default) {
        self.config = config
    }

    /// Toggle between connected and disconnected states.
    public func toggle() {
        if state == .connecting { return }
        if state == .idle || state == .disconnected {
            connect()
        } else {
            disconnect()
        }
    }

    /// Disconnect and return to idle.
    public func disconnect() {
        cleanUp()
        state = .idle
    }

    // MARK: - Private

    private func connect() {
        Task {
            state = .connecting

            for attempt in 1...config.maxRetries {
                do {
                    let tokenResponse = try await TokenService.fetchToken(
                        serverURL: config.serverURL,
                        userInfo: userInfo
                    )

                    let connectOptions = ConnectOptions(
                        autoSubscribe: true,
                        primaryTransportConnectTimeout: 30,
                        publisherTransportConnectTimeout: 30
                    )

                    let newRoom = Room(delegate: self)
                    room = newRoom

                    try await newRoom.connect(
                        url: config.livekitURL,
                        token: tokenResponse.token,
                        connectOptions: connectOptions
                    )
                    try await newRoom.localParticipant.setMicrophone(enabled: true)

                    state = .listening
                    startTimer()
                    return
                } catch {
                    print("[VoiceAIKit] Attempt \(attempt) failed: \(error.localizedDescription)")
                    cleanUp()
                    if attempt < config.maxRetries {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                    }
                }
            }

            state = .disconnected
        }
    }

    private func startAudioLevelMonitoring() {
        audioLevelTask?.cancel()
        audioLevelTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 33_000_000)
                let level = agentAudioAnalyzer.level
                handleAudioLevel(level)
            }
        }
    }

    private func handleAudioLevel(_ level: Float) {
        audioLevel = level
        guard state != .connecting else { return }

        if level > 0.06 {
            speakingHoldFrames = 25
            if state != .speaking { state = .speaking }
        } else if speakingHoldFrames > 0 {
            speakingHoldFrames -= 1
        } else if state != .listening {
            state = .listening
        }
    }

    private func startTimer() {
        elapsedSeconds = 0
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled { elapsedSeconds += 1 }
            }
        }
    }

    private func cleanUp() {
        timerTask?.cancel()
        timerTask = nil
        audioLevelTask?.cancel()
        audioLevelTask = nil
        agentAudioAnalyzer.detach()
        speakingHoldFrames = 0
        audioLevel = 0
        let roomToDisconnect = room
        room = nil
        Task { await roomToDisconnect?.disconnect() }
    }

    deinit {
        timerTask?.cancel()
        audioLevelTask?.cancel()
    }
}

// MARK: - RoomDelegate

extension VoiceAgentViewModel: RoomDelegate {
    nonisolated public func room(_ room: Room, participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) {
        if let audioTrack = publication.track as? RemoteAudioTrack {
            Task { @MainActor in
                agentAudioAnalyzer.attachToTrack(audioTrack)
                startAudioLevelMonitoring()
            }
        }
    }

    nonisolated public func room(_ room: Room, didDisconnectWithError error: LiveKitError?) {
        Task { @MainActor in
            cleanUp()
            state = .disconnected
        }
    }
}
