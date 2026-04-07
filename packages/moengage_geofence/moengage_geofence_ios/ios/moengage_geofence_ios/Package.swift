// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "moengage_geofence_ios",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "moengage-geofence-ios", targets: ["moengage_geofence_ios"])
    ],
    dependencies: [
        .package(url: "https://github.com/moengage/apple-plugin-geofence.git", exact: "4.8.0"),
        // For development
        // .package(path: "../../../../../../../../apple-plugin-geofence")
    ],
    targets: [
        .target(
            name: "moengage_geofence_ios",
            dependencies: [
                .product(name: "MoEngagePluginGeofence", package: "apple-plugin-geofence")
            ],
            path: "Sources"
        )
    ]
)
