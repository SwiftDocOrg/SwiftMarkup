public struct Parameter: Hashable, Codable {
    public let name: String
    public let content: String

    init(name: String, description: String) {
        self.name = name
        self.content = description
    }
}

// MARK: - CustomStringConvertible

extension Parameter: CustomStringConvertible {
    public var description: String {
        return "- \(name): \(content)"
    }
}
