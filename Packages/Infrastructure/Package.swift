// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkProvider",
            targets: ["NetworkProvider"]
        ),
        .library(
            name: "PersistentStorages",
            targets: ["PersistentStorages"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0"))
    ],
    targets: [
        .target(
            name: "NetworkProvider",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .target(name: "PersistentStorages"),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["NetworkProvider", "PersistentStorages"]
        )
    ]
)
