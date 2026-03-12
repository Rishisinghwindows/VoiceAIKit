import Foundation

/// User metadata sent to the backend when requesting a token.
public struct UserInfo: Sendable {
    public var name: String
    public var subject: String
    public var grade: String
    public var language: String
    public var type: String

    public init(
        name: String = "",
        subject: String = "",
        grade: String = "",
        language: String = "English",
        type: String = ""
    ) {
        self.name = name
        self.subject = subject
        self.grade = grade
        self.language = language
        self.type = type
    }
}
