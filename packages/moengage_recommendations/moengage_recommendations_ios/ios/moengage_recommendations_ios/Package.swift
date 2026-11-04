// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_recommendations_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-recommendations-ios", targets: ["moengage_recommendations_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/apple-plugin-recommendations.git", exact: "1.0.0"),
        // For development
        // .package(path: "../../../../../../../../apple-plugin-recommendations"),
    ],
    targets: [
        .target(
            name: "moengage_recommendations_ios",
            dependencies: [
                .product(name: "MoEngagePluginRecommendations", package: "apple-plugin-recommendations")
            ],
            path: "Sources"
        )
    ]
)
