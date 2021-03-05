public struct Callout: Hashable, Codable {
    public enum Delimiter: String, Hashable, CaseIterable, Codable {
        case precondition = "Precondition"
        case postcondition = "Postcondition"
        case requires = "Requires"
        case invariant = "Invariant"
        case complexity = "Complexity"
        case important = "Important"
        case warning = "Warning"
        case author = "Author"
        case copyright = "Copyright"
        case date = "Date"
        case seealso = "See Also"
        case since = "Since"
        case version = "Version"
        case attention = "Attention"
        case bug = "Bug"
        case experiment = "Experiment"
        case note = "Note"
        case remark = "Remark"
        case todo = "To Do"

        init?(_ description: String) {
            let description = description.normalized

            for delimiter in Delimiter.allCases {
                if description == delimiter.rawValue.normalized {
                    self = delimiter
                    return
                }
            }

            return nil
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
