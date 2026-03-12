import Foundation

/// Response from the token endpoint.
public struct TokenResponse: Decodable, Sendable {
    public let token: String
    public let url: String
}

/// Fetches LiveKit authentication tokens from the backend.
public enum TokenService {

    /// Fetch a token for the given user info and server URL.
    public static func fetchToken(
        serverURL: String,
        userInfo: UserInfo
    ) async throws -> TokenResponse {
        var components = URLComponents(string: "\(serverURL)/token")!
        components.queryItems = [
            URLQueryItem(name: "name", value: userInfo.name),
            URLQueryItem(name: "subject", value: userInfo.subject),
            URLQueryItem(name: "grade", value: userInfo.grade),
            URLQueryItem(name: "language", value: userInfo.language),
            URLQueryItem(name: "type", value: userInfo.type),
        ]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(TokenResponse.self, from: data)
    }
}
