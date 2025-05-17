// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "GlobalEntities",
            targets: ["GlobalEntities"]
        ),
        .library(
            name: "GlobalUsecase",
            targets: ["GlobalUsecase"]
        ),
        .library(
            name: "DomainRepositories",
            targets: ["DomainRepositories"]
        )
    ],
    targets: [
        .target(name: "GlobalEntities"),
        .target(
            name: "GlobalUsecase",
            dependencies: ["DomainRepositories"]
        ),
        .target(
            name: "DomainRepositories",
            dependencies: ["GlobalEntities"]
        ),
        .testTarget(
            name: "DomainKitTests",
            dependencies: ["GlobalEntities", "GlobalUsecase", "DomainRepositories"]
        )
    ]
)
