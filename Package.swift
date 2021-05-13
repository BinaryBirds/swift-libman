// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "swift-libman",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "swift-libman-cli", targets: ["SwiftLibmanCli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/console-kit", from: "4.1.0"),
        .package(url: "https://github.com/binarybirds/path-kit", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/shell-kit", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SwiftLibmanCli", dependencies: [
            .product(name: "ConsoleKit", package: "console-kit"),
            .product(name: "PathKit", package: "path-kit"),
            .product(name: "ShellKit", package: "shell-kit"),
        ]),
        .testTarget(name: "SwiftLibmanCliTests", dependencies: ["SwiftLibmanCli"]),
    ]
)
