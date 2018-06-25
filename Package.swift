// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "JSON",
    targets: [
        .target(name: "JSON", path: "Sources"),
        .testTarget(name: "JSONTests", dependencies: ["JSON"], path: "Tests"),
    ]
)
