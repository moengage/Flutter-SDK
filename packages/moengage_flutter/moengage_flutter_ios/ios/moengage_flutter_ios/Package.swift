// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_flutter_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-flutter-ios", targets: ["moengage_flutter_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/iOS-PluginBase.git", exact: "6.8.0"),
        // For development
        // .package(path: "../../../../../../../../iOS-PluginBase")
    ],
    targets: [
        .target(
            name: "moengage_flutter_ios",
            dependencies: [
                .product(name: "MoEngagePluginBase", package: "iOS-PluginBase")
            ],
            path: "Sources"
        )
    ]
)
