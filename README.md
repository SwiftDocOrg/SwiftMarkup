# SwiftMarkup

![CI][ci badge]
[![Documentation][documentation badge]][documentation]

SwiftMarkup parses [Swift Markup][swift markup] from documentation comments
into structured documentation entities.

```swift
import SwiftMarkup

let markdown = #"""
Creates a new bicycle with the provided parts and specifications.

- Remark: Satisfaction guaranteed!

The word *bicycle* first appeared in English print in 1868
to describe "Bysicles and trysicles" on the
"Champs Elysées and Bois de Boulogne".

- Parameters:
   - style: The style of the bicycle
   - gearing: The gearing of the bicycle
   - handlebar: The handlebar of the bicycle
   - frameSize: The frame size of the bicycle, in centimeters

- Returns: A beautiful, brand-new bicycle,
           custom-built just for you.
"""#
let documentation = try Documentation.parse(markdown)

documentation.summary // "Creates a new bicycle with the provided parts and specifications."

documentation.discussionParts.count // 2

let remark = documentation.discussionParts[0] as! Callout
remark.content // "Satisfaction guaranteed\\!"

let paragraph = documentation.discussionParts[1] as! String
paragraph.content // "The word *bicycle* first appeared in English print in 1868 [ ... ]"

documentation.parameters[0].name // "style"
documentation.parameters[0].description // "The style of the bicycle"

documentation.returns // A beautiful, brand-new bicycle, custom-built just for you.
```

This package is used by [swift-doc][swiftdoc]
in coordination with [CommonMark][commonmark] and [SwiftSemantics][swiftsemantics]
to generate documentation for Swift projects.

## Requirements

- Swift 5.1+

## Installation

### Swift Package Manager

Add the SwiftMarkup package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
  name: "YourProject",
  dependencies: [
    .package(
        url: "https://github.com/SwiftDocOrg/SwiftMarkup",
        from: "0.2.1"
    ),
  ]
)
```

Then run the `swift build` command to build your project.

## License

MIT

## Contact

Mattt ([@mattt](https://twitter.com/mattt))

[swiftdoc]: https://github.com/SwiftDocOrg/swift-doc
[commonmark]: https://github.com/SwiftDocOrg/CommonMark
[swiftsemantics]: https://github.com/SwiftDocOrg/SwiftSemantics
[swift markup]: https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/MarkupSyntax.html#//apple_ref/doc/uid/TP40016497-CH105-SW1
[ci badge]: https://github.com/SwiftDocOrg/SwiftMarkup/workflows/CI/badge.svg
[documentation badge]: https://github.com/SwiftDocOrg/SwiftMarkup/workflows/Documentation/badge.svg
[documentation]: https://github.com/SwiftDocOrg/SwiftMarkup/wiki
