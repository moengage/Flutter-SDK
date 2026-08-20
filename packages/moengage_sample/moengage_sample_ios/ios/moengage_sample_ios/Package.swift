// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_sample_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-sample-ios", targets: ["moengage_sample_ios"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "moengage_sample_ios",
            dependencies: [],
            path: "Sources"
        )
    ]
)
