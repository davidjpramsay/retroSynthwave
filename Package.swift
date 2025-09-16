// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "RetroSynthwave",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "RetroSynthwave",
            targets: ["RetroSynthwave"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RetroSynthwave",
            dependencies: [],
            path: "Sources/RetroSynthwave"
        )
    ]
)
