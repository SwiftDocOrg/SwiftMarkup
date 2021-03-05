@_exported import CommonMark

/// A named parameter for a function, initializer, method, or subscript.
public struct Parameter: Hashable, Codable {
    /// The name of the parameter.
    public let name: String

    /// The documentation content for the parameter.
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
