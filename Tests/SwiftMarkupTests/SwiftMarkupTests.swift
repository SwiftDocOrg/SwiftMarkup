@testable import SwiftMarkup
import XCTest

let markdown = #"""
Creates a new bicycle with the provided parts and specifications.

- Remark: Satisfaction guaranteed!

The word *bicycle* first appeared in English print in 1868
to describe "Bysicles and trysicles" on the
"Champs Elysées and Bois de Boulogne".
The word was first used in 1847 in a French publication to describe
an unidentified two-wheeled vehicle, possibly a carriage.
The design of the bicycle was an advance on the velocipede,
although the words were used with some degree of overlap for a time.

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
        XCTAssertEqual(documentation.discussionParts.count, 4)

        let remark = documentation.discussionParts[0] as! Documentation.Callout
        XCTAssertEqual(remark.content, "Satisfaction guaranteed\\!")

        let discussion = documentation.discussionParts[1] as! String
        XCTAssert(discussion.starts(with: "The word *bicycle*"))

        let author = documentation.discussionParts[2] as! Documentation.Callout
        XCTAssertEqual(author.content, "Mattt")

        let complexity = documentation.discussionParts[3] as! Documentation.Callout
        XCTAssertEqual(complexity.content, "`O(1)`")

        XCTAssertEqual(documentation.parameters.count, 4)
        XCTAssertEqual(documentation.parameters[0].name, "style")
        XCTAssertEqual(documentation.parameters[0].description,"The style of the bicycle")
        XCTAssertEqual(documentation.parameters[1].name, "gearing")
        XCTAssertEqual(documentation.parameters[1].description,"The gearing of the bicycle")
        XCTAssertEqual(documentation.parameters[2].name, "handlebar")
        XCTAssertEqual(documentation.parameters[2].description,"The handlebar of the bicycle")
        XCTAssertEqual(documentation.parameters[3].name, "frameSize")
        XCTAssertEqual(documentation.parameters[3].description,"The frame size of the bicycle, in centimeters")

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

        XCTAssertEqual(original, decoded)
    }
}
