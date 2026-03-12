// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "VoiceAIKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "VoiceAIKit",
            targets: ["VoiceAIKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/client-sdk-swift.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "VoiceAIKit",
            dependencies: [
                .product(name: "LiveKit", package: "client-sdk-swift"),
            ]
        ),
    ]
)
