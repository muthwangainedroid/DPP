// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DPProtocols",
    platforms: [
      .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DPProtocols",
            targets: ["DPProtocols"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0"),
        .package(url: "https://github.com/NoTests/RxFeedback.swift.git", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DPProtocols",
            dependencies: ["RxSwift", "RxFeedback"]),
        .testTarget(
            name: "DPProtocolsTests",
            dependencies: ["DPProtocols"]),
    ]
)
