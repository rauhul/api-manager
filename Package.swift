// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIManager",
    products: [
        .library(name: "APIManager", targets: ["APIManager"])
    ],
    targets: [
        .target(name: "APIManager", dependencies: []),
        .testTarget(name: "APIManagerTests", dependencies: ["APIManager"])
    ]
)
