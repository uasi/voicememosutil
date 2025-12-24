// swift-tools-version: 6.2
// SPDX-License-Identifier: 0BSD

import PackageDescription

let package = Package(
    name: "voicememosutil",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.7.0")
    ],
    targets: [
        .executableTarget(
            name: "voicememosutil",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "VoiceMemosUtilTests",
            dependencies: [.target(name: "voicememosutil")],
            resources: [.copy("Resources")]),
    ]
)
