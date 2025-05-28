// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BLFLightweightExtension",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "BLFLightweightExtension",
            targets: ["BLFLightweightExtension"]
        )
    ],
    targets: [
        .executableTarget(
            name: "BLFLightweightExtension",
            dependencies: [],
            path: "Sources"
        )
    ]
)
