// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DataKit",
            targets: ["DataKit"]),
    ],
    dependencies: [
        .package(path: "../CoreKit"),
        .package(path: "../DomainKit"),
        .package(path: "../Infrastructure")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DataKit",
            dependencies: [
                "CoreKit",
                .product(name: "NetworkProvider", package: "Infrastructure"),
                .product(name: "GlobalEntities", package: "DomainKit"),
                .product(name: "DomainRepositories", package: "DomainKit")
            ]
        ),
        .testTarget(
            name: "DataKitTests",
            dependencies: ["DataKit"]
        )
    ]
)
