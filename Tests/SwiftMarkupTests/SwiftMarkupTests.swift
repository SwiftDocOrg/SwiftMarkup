@testable import SwiftMarkup
import XCTest

let markdown = #"""
Creates a new bicycle with the provided parts and specifications.

- Remark: Satisfaction guaranteed!

* * *

The word *bicycle* first appeared in English print in 1868
to describe "Bysicles and trysicles" on the
"Champs Elysées and Bois de Boulogne".

The more common types of bicycles include:

- utility bicycles
- mountain bicycles
- racing bicycles
- touring bicycles
- hybrid bicycles
- cruiser bicycles

```swift
let bicycle = Bicycle(gearing: .fixed, handlebar: .drop, frameSize: 170)
```

- Author: Mattt
- Complexity: `O(1)`
- Parameter style: The style of the bicycle
- Parameters:
   - gearing: The gearing of the bicycle
   - handlebar: The handlebar of the bicycle
   - frameSize: The frame size of the bicycle, in centimeters
- Throws:
    - `Error.invalidSpecification` if something's wrong with the design
    - `Error.partOutOfStock` if a part needs to be ordered
- Returns: A beautiful, brand-new bicycle,
           custom-built just for you.
"""#

final class SwiftMarkupTests: XCTestCase {
    func testSwiftMarkupParsing() throws {
        let documentation = try Documentation.parse(markdown)

        XCTAssertEqual(documentation.isEmpty, false)

        XCTAssertEqual(documentation.summary?.description, "Creates a new bicycle with the provided parts and specifications.\n")
        XCTAssertEqual(documentation.discussionParts.count, 8)

        guard case .callout(let remark) = documentation.discussionParts[0] else { return XCTFail() }
        XCTAssertEqual(remark.delimiter, .remark)
        XCTAssertEqual(remark.content, #"Satisfaction guaranteed\!"#)

        guard case .thematicBreak = documentation.discussionParts[1] else { return XCTFail() }

        guard case .paragraph(let paragraph) = documentation.discussionParts[2] else { return XCTFail() }
        XCTAssert(paragraph.description.starts(with: "The word *bicycle*"))

        guard case .list(let list) = documentation.discussionParts[4] else { return XCTFail() }
        XCTAssertEqual(list.children.count, 6)
        XCTAssertEqual(list.children[0].description.trimmingCharacters(in: .whitespacesAndNewlines), "- utility bicycles")

        guard case .codeBlock(let example) = documentation.discussionParts[5] else { return XCTFail() }
        XCTAssertEqual(example.fenceInfo, "swift")
        XCTAssertEqual(example.literal, "let bicycle = Bicycle(gearing: .fixed, handlebar: .drop, frameSize: 170)\n")

        guard case .callout(let author) = documentation.discussionParts[6] else { return XCTFail() }
        XCTAssertEqual(author.delimiter, .author)
        XCTAssertEqual(author.content, "Mattt")

        guard case .callout(let complexity) = documentation.discussionParts[7] else { return XCTFail() }
        XCTAssertEqual(complexity.delimiter, .complexity)
        XCTAssertEqual(complexity.content, "`O(1)`")

        XCTAssertEqual(documentation.parameters.count, 4)
        XCTAssertEqual(documentation.parameters[0].name, "style")
        XCTAssertEqual(documentation.parameters[0].content.description, "The style of the bicycle\n")
        XCTAssertEqual(documentation.parameters[1].name, "gearing")
        XCTAssertEqual(documentation.parameters[1].content.description, "The gearing of the bicycle\n")
        XCTAssertEqual(documentation.parameters[2].name, "handlebar")
        XCTAssertEqual(documentation.parameters[2].content.description, "The handlebar of the bicycle\n")
        XCTAssertEqual(documentation.parameters[3].name, "frameSize")
        XCTAssertEqual(documentation.parameters[3].content.description, "The frame size of the bicycle, in centimeters\n")

        XCTAssertEqual(documentation.returns?.description, "A beautiful, brand-new bicycle, custom-built just for you.\n")

        XCTAssertEqual(documentation.throws?.description,
        #"""
          - `Error.invalidSpecification` if something's wrong with the design
          - `Error.partOutOfStock` if a part needs to be ordered

        """#)
    }

    func testEncodingAndDecoding() throws {
        let original = try Documentation.parse(markdown)

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Documentation.self, from: data)

        XCTAssertEqual(original.summary?.description, decoded.summary?.description)
        for (expected, actual) in zip(original.discussionParts, decoded.discussionParts) {
            XCTAssertEqual(actual, expected)
        }
        XCTAssertEqual(original.parameters.description, decoded.parameters.description)
        XCTAssertEqual(original.throws?.description, decoded.throws?.description)
        XCTAssertEqual(original.returns?.description, decoded.returns?.description)
    }
}
