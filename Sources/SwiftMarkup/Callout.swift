public struct Callout: Hashable, Codable {
    public enum Delimiter: String, Hashable, CaseIterable, Codable {
        case precondition
        case postcondition
        case requires
        case invariant
        case complexity
        case important
        case warning
        case author
        case copyright
        case date
        case seealso
        case since
        case version
        case attention
        case bug
        case experiment
        case note
        case remark
        case todo
    }

    public var delimiter: Delimiter
    public var content: String
}

// MARK: - CustomStringConvertible

extension Callout: CustomStringConvertible {
    public var description: String {
        return "- \(delimiter.rawValue.capitalized): \(content)"
    }
}
