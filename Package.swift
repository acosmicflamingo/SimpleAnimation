// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleAnimation",
    platforms: [
        .iOS(.v8),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "SimpleAnimation",
            targets: ["SimpleAnimation"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SimpleAnimation",
            dependencies: [],
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SimpleAnimationTests",
            dependencies: ["SimpleAnimation"],
            exclude: ["Info.plist"]
        )
    ]
)
