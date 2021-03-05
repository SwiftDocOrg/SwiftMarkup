@_exported import CommonMark

public struct Parameter: Hashable, Codable {
    public let name: String
    public let content: Document

    init(name: String, description: String) throws {
        self.name = name
        self.content = try Document(description)
    }
}

// MARK: - CustomStringConvertible

extension Parameter: CustomStringConvertible {
    public var description: String {
        return "- \(name): \(content)"
    }
}
