public struct Callout: Hashable, Codable {
    public enum Delimiter: String, Hashable, CaseIterable, Codable {
        case attention = "Attention"
        case author = "Author"
        case authors = "Authors"
        case bug = "Bug"
        case complexity = "Complexity"
        case copyright = "Copyright"
        case date = "Date"
        case experiment = "Experiment"
        case important = "Important"
        case invariant = "Invariant"
        case note = "Note"
        case precondition = "Precondition"
        case postcondition = "Postcondition"
        case remark = "Remark"
        case requires = "Requires"
        case seealso = "See Also"
        case since = "Since"
        case todo = "To Do"
        case version = "Version"
        case warning = "Warning"

        init?(_ description: String) {
            let description = description.normalized

            if let delimiter = Delimiter.allCases.first(where: { $0.rawValue.normalized == description }) {
                self = delimiter
            } else {
                return nil
            }
        }
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

fileprivate extension String {
    var normalized: String {
        filter { !$0.isWhitespace }.lowercased()
    }
}
