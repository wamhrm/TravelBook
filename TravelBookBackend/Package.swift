// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TravelBookBackend",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        .package(url: "https://github.com/soto-project/soto.git", from: "6.0.0")
    ],
    targets: [
        .executableTarget(
            name: "TravelBookBackend",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "SotoS3", package: "soto")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "TravelBookBackendTests",
            dependencies: [
                .target(name: "TravelBookBackend"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
