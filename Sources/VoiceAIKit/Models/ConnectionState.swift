import Foundation

/// Represents the connection state of the voice agent.
public enum ConnectionState: Equatable, Sendable {
    case idle
    case connecting
    case listening
    case speaking
    case disconnected
}
