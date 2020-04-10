import CommonMark

/// A part of the discussion.
public enum DiscussionPart {
    case blockQuote(BlockQuote)
    case callout(Callout)
    case codeBlock(CodeBlock)
    case heading(Heading)
    case htmlBlock(HTMLBlock)
    case list(List)
    case paragraph(Paragraph)

    init?(_ node: Node & Block) {
        switch node {
        case let blockQuote as BlockQuote:
            self = .blockQuote(blockQuote)
        case let codeBlock as CodeBlock:
            self = .codeBlock(codeBlock)
        case let heading as Heading:
            self = .heading(heading)
        case let htmlBlock as HTMLBlock:
            self = .htmlBlock(htmlBlock)
        case let list as List:
            self = .list(list)
        case let paragraph as Paragraph:
            self = .paragraph(paragraph)
        default:
            return nil
        }
    }
}

// MARK: - Equatable

extension DiscussionPart: Equatable {
    public static func == (lhs: DiscussionPart, rhs: DiscussionPart) -> Bool {
        return lhs.description == rhs.description
    }
}

// MARK: - Hashable

extension DiscussionPart: Hashable {}

// MARK: - CustomStringConvertible

extension DiscussionPart: CustomStringConvertible {
    public var description: String {
        switch self {
        case .blockQuote(let blockQuote):
            return blockQuote.description
        case .callout(let callout):
            return callout.description
        case .codeBlock(let codeBlock):
            return codeBlock.description
        case .heading(let heading):
            return heading.description
        case .htmlBlock(let htmlBlock):
            return htmlBlock.description
        case .list(let list):
            return list.description
        case .paragraph(let paragraph):
            return paragraph.description
        }
    }
}

// MARK: - Codable

extension DiscussionPart: Codable {
    private enum CodingKeys: String, CodingKey {
        case blockQuote
        case callout
        case codeBlock
        case heading
        case htmlBlock
        case list
        case paragraph
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.blockQuote) {
            let blockQuote = try container.decode(BlockQuote.self, forKey: .blockQuote)
            self = .blockQuote(blockQuote)
        } else if container.contains(.callout) {
            let callout = try container.decode(Callout.self, forKey: .callout)
            self = .callout(callout)
        } else if container.contains(.codeBlock) {
            let codeBlock = try container.decode(CodeBlock.self, forKey: .codeBlock)
            self = .codeBlock(codeBlock)
        } else if container.contains(.heading) {
            let heading = try container.decode(Heading.self, forKey: .heading)
            self = .heading(heading)
        } else if container.contains(.htmlBlock) {
            let htmlBlock = try container.decode(HTMLBlock.self, forKey: .htmlBlock)
            self = .htmlBlock(htmlBlock)
        } else if container.contains(.list) {
            let list = try container.decode(List.self, forKey: .list)
            self = .list(list)
        } else if container.contains(.paragraph) {
            let paragraph = try container.decode(Paragraph.self, forKey: .paragraph)
            self = .paragraph(paragraph)
        } else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "invalid or missing key")
            throw DecodingError.dataCorrupted(context)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .blockQuote(let blockQuote):
            try container.encode(blockQuote, forKey: .blockQuote)
        case .callout(let callout):
            try container.encode(callout, forKey: .callout)
        case .codeBlock(let codeBlock):
            try container.encode(codeBlock, forKey: .codeBlock)
        case .heading(let heading):
            try container.encode(heading, forKey: .heading)
        case .htmlBlock(let htmlBlock):
            try container.encode(htmlBlock, forKey: .htmlBlock)
        case .list(let list):
            try container.encode(list, forKey: .list)
        case .paragraph(let paragraph):
            try container.encode(paragraph, forKey: .paragraph)
        }
    }
}
