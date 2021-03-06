// swift-tools-version:5.3

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
        .package(name: "CommonMark",
                 url: "https://github.com/SwiftDocOrg/CommonMark.git",
                 .upToNextMinor(from: "0.5.0")),
    ],
    targets: [
        .target(
            name: "SwiftMarkup",
            dependencies: [
                .product(name: "CommonMark", package: "CommonMark")
            ]
        ),
        .testTarget(
            name: "SwiftMarkupTests",
            dependencies: [
                .target(name: "SwiftMarkup")
            ]
        )
    ]
)
