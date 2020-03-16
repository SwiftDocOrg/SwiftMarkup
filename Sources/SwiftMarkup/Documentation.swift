import CommonMark
import Foundation

/// A part of the discussion (either text or a callout).
public protocol DiscussionPart {}
extension String: DiscussionPart {}
extension Documentation.Callout: DiscussionPart {}

// MARK: -

/// Documentation for a Swift declaration.
public struct Documentation {
    /// The summary.
    public var summary: String?

    /// The text segments and callouts that comprise the discussion, if any.
    public var discussionParts: [DiscussionPart] = []

    /// The documented parameters.
    public var parameters: [(name: String, description: String)] = []

    /// The documented return value.
    public var returns: String?

    /// The documented error throwing behavior.
    public var `throws`: String?

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
        parser.visitDocument(document)
        return parser.documentation
    }
}

// MARK: Equatable

extension Documentation: Equatable {
    public static func == (lhs: Documentation, rhs: Documentation) -> Bool {
        guard lhs.summary == rhs.summary,
            lhs.returns == rhs.returns,
            lhs.parameters.count == rhs.parameters.count
            else {
                return false
        }

        for (lp, rp) in zip(lhs.discussionParts, rhs.discussionParts) {
            switch (lp, rp) {
            case let (lp, rp) as (String, String):
                guard lp == rp else { return false }
            case let (lp, rp) as (Callout, Callout):
                guard lp == rp else { return false }
            default:
                return false
            }
        }

        for (lp, rp) in zip(lhs.parameters, rhs.parameters) {
            guard lp.name == rp.name, lp.description == rp.description else { return false }
        }

        return true
    }
}

// MARK: Hashable

extension Documentation: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(summary)
        hasher.combine(discussionParts.map { String(describing: $0) })
        for case let (name, description) in parameters {
            hasher.combine(name)
            hasher.combine(description)
        }
        hasher.combine(returns)
        hasher.combine(`throws`)
    }
}

// MARK: Codable

extension Documentation: Codable {
    private enum CodingKeys: String, CodingKey {
        case summary
        case discussionParts
        case parameters
        case returns
        case `throws`
    }

    private enum ParameterCodingKeys: String, CodingKey {
        case name
        case description
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.summary = try container.decode(String.self, forKey: .summary)

        do {
            var discussionParts: [DiscussionPart] = []

            var nestedUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .discussionParts)
            while !nestedUnkeyedContainer.isAtEnd {
                if let callout = try? nestedUnkeyedContainer.decode(Callout.self) {
                    discussionParts.append(callout)
                } else {
                    let string = try nestedUnkeyedContainer.decode(String.self)
                    discussionParts.append(string)
                }
            }

            self.discussionParts = discussionParts
        }

        do {
            var parameters: [(String, String)] = []

            var nestedUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .parameters)
            while !nestedUnkeyedContainer.isAtEnd {
                let nestedKeyedContainer = try nestedUnkeyedContainer.nestedContainer(keyedBy: ParameterCodingKeys.self)
                let name = try nestedKeyedContainer.decode(String.self, forKey: .name)
                let description = try nestedKeyedContainer.decode(String.self, forKey: .description)
                parameters.append((name, description))
            }

            self.parameters = parameters
        }

        self.returns = try container.decode(String.self, forKey: .returns)
        self.throws = try container.decode(String.self, forKey: .throws)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(summary, forKey: .summary)

        do {
            for part in discussionParts {
                var nestedContainer = container.nestedUnkeyedContainer(forKey: .discussionParts)
                switch part {
                case let callout as Callout:
                    try nestedContainer.encode(callout)
                case let string as String:
                    try nestedContainer.encode(string)
                default:
                    let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "invalid part")
                    throw EncodingError.invalidValue(part, context)
                }
            }
        }

        do {
            var nestedUnkeyedContainer = container.nestedUnkeyedContainer(forKey: .parameters)
            for case let (name, description) in parameters {
                var nestedKeyedContainer = nestedUnkeyedContainer.nestedContainer(keyedBy: ParameterCodingKeys.self)
                try nestedKeyedContainer.encode(name, forKey: .name)
                try nestedKeyedContainer.encode(description, forKey: .description)
            }
        }

        try container.encode(returns, forKey: .returns)
        try container.encode(`throws`, forKey: .throws)
    }
}

// MARK: -

extension Documentation {
    public struct Callout: Hashable, Codable {
        public var delimiter: Delimiter
        public var content: String

        public enum Delimiter: String, CaseIterable, Hashable, Codable {
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
    }
}

// MARK: -

extension Documentation {
    private final class Parser {
        private enum State {
            case initial
            case summary
            case discussion
            case parameters
        }

        private var state: State = .initial

        var documentation: Documentation = Documentation()

        func visitDocument(_ node: Document) {
            assert(state == .initial)
            guard let firstChild = node.children.first else {
                return
            }

            state = firstChild is Paragraph ? .summary : .discussion

            for case let child in node.children {
                visitBlock(child)
            }
        }

        private func visitBlock(_ node: Node & Block) {
            switch (state, node) {
            case (.summary, _):
                documentation.summary = node.description.trimmingCharacters(in: .whitespacesAndNewlines)
                state = .discussion
            case (.discussion, let list as List) where list.kind == .bullet:
                visitBulletList(list)
            default:
                documentation.discussionParts += [node.description]
            }
        }

        private func visitBulletList(_ node: List) {
            for item in node.children {
                visitBulletListItem(item)
            }

            state = .discussion
        }

        private func visitBulletListItem(_ node: List.Item) {
            let string = node.description
            let pattern = #"\s*[\-\+\*]\s*(?<parameter>(?:Parameter\s+)?)(?<name>[\w\h]+):(\s*(?<description>.+))?"#
            let regularExpression = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators, .caseInsensitive])

            guard let match = regularExpression.firstMatch(in: string, options: [], range: NSRange(string.startIndex ..< string.endIndex, in: string)),
                let parameterRange = Range(match.range(at: 1), in: string),
                let nameRange = Range(match.range(at: 2), in: string),
                let descriptionRange = Range(match.range(at: 3), in: string)
            else {
                return
            }

            func normalize<S: StringProtocol>(_ string: S) -> String {
                return string.split { $0.isNewline }
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .joined(separator: " ")
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
                documentation.parameters += [(name, description)]
            case .discussion:
                if name.caseInsensitiveCompare("parameters") == .orderedSame {
                    state = .parameters
                    for case let nestedBulletList as List in node.children where nestedBulletList.kind == .bullet {
                        visitBulletList(nestedBulletList)
                    }
                } else if name.caseInsensitiveCompare("parameter") == .orderedSame {
                    documentation.parameters += [(name, description)]
                } else if name.caseInsensitiveCompare("returns") == .orderedSame {
                    documentation.returns = description
                } else if name.caseInsensitiveCompare("throws") == .orderedSame {
                    documentation.throws = description
                } else if let delimiter = Callout.Delimiter(rawValue: name.lowercased()) {
                    documentation.discussionParts += [Callout(delimiter: delimiter, content: description)]
                } else {
                    documentation.discussionParts += [node.description]
                }
            default:
                assertionFailure("unexpected state: \(state)")
            }
        }
    }
}
