// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_cards_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-cards-ios", targets: ["moengage_cards_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/apple-plugin-cards.git", exact: "3.8.0"),
        // For development
        // .package(path: "../../../../../../../../apple-plugin-cards"),
    ],
    targets: [
        .target(
            name: "moengage_cards_ios",
            dependencies: [
                .product(name: "MoEngagePluginCards", package: "apple-plugin-cards")
            ],
            path: "Sources"
        )
    ]
)
