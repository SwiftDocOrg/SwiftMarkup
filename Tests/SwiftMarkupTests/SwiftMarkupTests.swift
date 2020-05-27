@testable import SwiftMarkup
import CommonMark
import XCTest

let markdown = #"""
Creates a new bicycle with the provided parts and specifications.

- Remark: Satisfaction guaranteed!

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

        XCTAssertEqual(documentation.summary, "Creates a new bicycle with the provided parts and specifications.")
        XCTAssertEqual(documentation.discussionParts.count, 7)

        guard case .callout(let remark) = documentation.discussionParts[0] else { fatalError() }
        XCTAssertEqual(remark.delimiter, .remark)
        XCTAssertEqual(remark.content, "Satisfaction guaranteed\\!")

        guard case .paragraph(let paragraph) = documentation.discussionParts[1] else { fatalError() }
        XCTAssert(paragraph.description.starts(with: "The word *bicycle*"))

        guard case .list(let list) = documentation.discussionParts[3] else { fatalError() }
        XCTAssertEqual(list.children.count, 6)
        XCTAssertEqual(list.children[0].description.trimmingCharacters(in: .whitespacesAndNewlines), "- utility bicycles")

        guard case .codeBlock(let example) = documentation.discussionParts[4] else { fatalError() }
        XCTAssertEqual(example.fenceInfo, "swift")
        XCTAssertEqual(example.literal, "let bicycle = Bicycle(gearing: .fixed, handlebar: .drop, frameSize: 170)\n")

        guard case .callout(let author) = documentation.discussionParts[5] else { fatalError() }
        XCTAssertEqual(author.delimiter, .author)
        XCTAssertEqual(author.content, "Mattt")

        guard case .callout(let complexity) = documentation.discussionParts[6] else { fatalError() }
        XCTAssertEqual(complexity.delimiter, .complexity)
        XCTAssertEqual(complexity.content, "`O(1)`")

        XCTAssertEqual(documentation.parameters.count, 4)
        XCTAssertEqual(documentation.parameters[0].name, "style")
        XCTAssertEqual(documentation.parameters[0].content,"The style of the bicycle")
        XCTAssertEqual(documentation.parameters[1].name, "gearing")
        XCTAssertEqual(documentation.parameters[1].content,"The gearing of the bicycle")
        XCTAssertEqual(documentation.parameters[2].name, "handlebar")
        XCTAssertEqual(documentation.parameters[2].content,"The handlebar of the bicycle")
        XCTAssertEqual(documentation.parameters[3].name, "frameSize")
        XCTAssertEqual(documentation.parameters[3].content,"The frame size of the bicycle, in centimeters")

        XCTAssertEqual(documentation.returns, "A beautiful, brand-new bicycle, custom-built just for you.")

        XCTAssertEqual(documentation.throws,
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

        XCTAssertEqual(original.summary, decoded.summary)
        for (expected, actual) in zip(original.discussionParts, decoded.discussionParts) {
            XCTAssertEqual(actual, expected)
        }
        XCTAssertEqual(original.parameters, decoded.parameters)
        XCTAssertEqual(original.throws, decoded.throws)
        XCTAssertEqual(original.returns, decoded.returns)
    }
}
