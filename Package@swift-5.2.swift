// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftMarkup",
    products: [
        .library(
            name: "SwiftMarkup",
            targets: ["SwiftMarkup"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftDocOrg/CommonMark.git",
                 .upToNextMinor(from: "0.5.0")),
    ],
    targets: [
        .target(
            name: "SwiftMarkup",
            dependencies: ["CommonMark"]
        ),
        .testTarget(
            name: "SwiftMarkupTests",
            dependencies: ["SwiftMarkup"]
        )
    ]
)
