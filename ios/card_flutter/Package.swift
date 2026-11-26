// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "card_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "card-flutter", targets: ["card_flutter"])
    ],
    dependencies: [
        // Keep in step with the Card-iOS version in ../card_flutter.podspec.
        .package(url: "https://github.com/Tap-Payments/Card-iOS.git", exact: "1.0.10")
    ],
    targets: [
        .target(
            name: "card_flutter",
            dependencies: [
                .product(name: "Card-iOS", package: "Card-iOS")
            ]
        )
    ]
)
