// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_inbox_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-inbox-ios", targets: ["moengage_inbox_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/apple-plugin-inbox.git", exact: "4.8.0"),
        // For development
        // .package(path: "../../../../../../../../apple-plugin-inbox")
    ],
    targets: [
        .target(
            name: "moengage_inbox_ios",
            dependencies: [
                .product(name: "MoEngagePluginInbox", package: "apple-plugin-inbox")
            ],
            path: "Sources"
        )
    ]
)
