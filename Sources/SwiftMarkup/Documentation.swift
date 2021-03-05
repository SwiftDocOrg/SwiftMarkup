@_exported import CommonMark
import Foundation

/// Documentation for a Swift declaration.
public struct Documentation: Hashable, Codable {
    /// The summary.
    public var summary: Paragraph?

    /// The text segments and callouts that comprise the discussion, if any.
    public var discussionParts: [DiscussionPart] = []

    /// The documented parameters.
    public var parameters: [Parameter] = []

    /// The documented return value.
    public var returns: Document?

    /// The documented error throwing behavior.
    public var `throws`: Document?

    /// Whether the documentation has any content.
    public var isEmpty: Bool {
        return summary == nil &&
                `throws` == nil &&
                returns == nil &&
                discussionParts.isEmpty &&
                parameters.isEmpty
    }

    /**
     Create and return documentation from Swift Markup text.

     - Parameters
        - text: The documentation text in Swift Markup (CommonMark) format.
     - Throws:
        - `CommonMark.Document.Error`
          if the provided text can't be parsed.
     - Returns: A structured representation of the documentation.
     */
    public static func parse(_ text: String?) throws -> Documentation {
        guard let text = text else { return .init() }
        let document = try Document(text)
        let parser = Parser()
        try parser.visitDocument(document)
        return parser.documentation
    }
}

// MARK: -

extension Documentation {
    private final class Parser {
        private enum State {
            case summary
            case discussion
            case parameters
        }

        private var state: State = .summary

        var documentation: Documentation = Documentation()

        func visitDocument(_ node: Document) throws {
            for case let child in node.removeChildren() {
                try visitBlock(child)
            }
        }

        private func visitBlock(_ node: Node & Block) throws {
            switch (state, node) {
            case (.summary, let node as Paragraph):
                documentation.summary = node
                state = .discussion
            case (.discussion, let list as List) where list.kind == .bullet:
                try visitBulletList(list)
            default:
                if let part = DiscussionPart(node) {
                    documentation.discussionParts += [part]
                }
            }
        }

        private func visitBulletList(_ node: List) throws {
            for item in node.children {
                try visitBulletListItem(item)
            }

            state = .discussion
        }

        private func visitBulletListItem(_ node: List.Item) throws {
            func appendListItemToDiscussion(_ item: List.Item) {
                var list: List
                if case let .list(lastPart) = documentation.discussionParts.last {
                    list = lastPart
                    documentation.discussionParts.removeLast()
                } else {
                    list = List()
                }

                list.append(child: item)
                documentation.discussionParts.append(.list(list))
            }

            func normalize<S: StringProtocol>(_ string: S) -> String {
                return string.split { $0.isNewline }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .joined(separator: " ")
            }

            let string = node.description
            let pattern = #"\s*[\-\+\*]\s*(?<parameter>(?:Parameter\s+)?)(?<name>[\w\h]+):(\s*(?<description>.+))?"#
            let regularExpression = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators, .caseInsensitive])

            guard let match = regularExpression.firstMatch(in: string, options: [], range: NSRange(string.startIndex ..< string.endIndex, in: string)),
                let parameterRange = Range(match.range(at: 1), in: string),
                let nameRange = Range(match.range(at: 2), in: string),
                let descriptionRange = Range(match.range(at: 3), in: string)
            else {
                appendListItemToDiscussion(node)
                return
            }

            let name: String, description: String
            name = normalize(string[nameRange])
            if node.children.count > 1 {
                description = node.children.suffix(from: 1).map { $0.description }.joined(separator: "\n")
            } else {
                description = normalize(string[descriptionRange])
            }

            switch state {
            case .parameters,
                 _ where !parameterRange.isEmpty:
                let parameter = Parameter(name: name, description: description)
                documentation.parameters += [parameter]
            case .discussion:
                if name.caseInsensitiveCompare("parameters") == .orderedSame {
                    state = .parameters
                    for case let nestedBulletList as List in node.children where nestedBulletList.kind == .bullet {
                        try visitBulletList(nestedBulletList)
                    }
                } else if name.caseInsensitiveCompare("parameter") == .orderedSame {
                    let parameter = Parameter(name: name, description: description)
                    documentation.parameters += [parameter]
                } else if name.caseInsensitiveCompare("returns") == .orderedSame {
                    documentation.returns = try Document(description)
                } else if name.caseInsensitiveCompare("throws") == .orderedSame {
                    documentation.throws = try Document(description)
                } else if let delimiter = Callout.Delimiter(rawValue: name.lowercased()) {
                    let callout = Callout(delimiter: delimiter, content: description)
                    documentation.discussionParts += [.callout(callout)]
                } else {
                    appendListItemToDiscussion(node)
                }
            default:
                assertionFailure("unexpected state: \(state)")
                return
            }
        }
    }
}
