// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-ordinal-tagged",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Ordinal Tagged",
            targets: ["Ordinal Tagged"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal-cardinal",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal-property",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Ordinal Tagged",
            dependencies: [
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Property", package: "swift-ordinal-property"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Cardinal Standard Library Integration", package: "swift-cardinal"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "Ordinal Tagged Tests",
            dependencies: [
                "Ordinal Tagged",
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Cardinal", package: "swift-ordinal-cardinal"),
                .product(name: "Ordinal Property", package: "swift-ordinal-property"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .define(
            "SYNCHRONIZATION_AVAILABLE",
            .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])
        )
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
