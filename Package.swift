// swift-tools-version:6.0
import PackageDescription

// VoidCore is the pure-Foundation logic layer shared by the Void app.
// It deliberately has zero SwiftUI/AppKit/UIKit imports so it builds and
// tests on any platform Swift supports (this package is exercised with
// `swift test` on Linux in CI-style checks, in addition to being consumed
// by the SwiftUI app target wired up via project.yml/XcodeGen).
let package = Package(
    name: "VoidCore",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "VoidCore", targets: ["VoidCore"])
    ],
    targets: [
        .target(
            name: "VoidCore",
            path: "Sources/VoidCore"
        ),
        .testTarget(
            name: "VoidCoreTests",
            dependencies: ["VoidCore"],
            path: "Tests/VoidCoreTests"
        ),
    ]
)
