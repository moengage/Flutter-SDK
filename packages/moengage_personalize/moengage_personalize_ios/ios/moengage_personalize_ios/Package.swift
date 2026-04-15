// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_personalize_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-personalize-ios", targets: ["moengage_personalize_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/apple-plugin-personalize.git", exact: "1.0.0"),
        // For development
        // .package(path: "../../../../../../../../apple-plugin-personalize")
    ],
    targets: [
        .target(
            name: "moengage_personalize_ios",
            dependencies: [
                .product(name: "MoEngagePluginPersonalize", package: "apple-plugin-personalize")
            ],
            path: "Sources"
        )
    ]
)
