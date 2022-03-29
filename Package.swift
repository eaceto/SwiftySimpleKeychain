// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// BEGIN CI/CD Space
let libraryName = "SwiftySimpleKeychain"
let libraryVersion = "1.0.0"
// END CI/CD Space

let package = Package(
    name: libraryName,
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
        .watchOS(.v5),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: libraryName,
            targets: [libraryName]
        ),
        .library(
            name: "\(libraryName)_RSAHelper",
            targets: ["\(libraryName)_RSAHelper"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", .upToNextMajor(from: "3.12.0")),
        .package(name: "Quick", url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", branch: "main") // beResult matcher is not yet published
    ],
    targets: [
        .target(
            name: libraryName,
            dependencies: [
                .product(name: "Danger", package: "swift")
            ],
            cSettings: [
                .define("\(libraryName)_VERSION".uppercased(), to: libraryVersion),
            ]            
        ),
        .target(
            name: "\(libraryName)_RSAHelper",
            dependencies: [
                .product(name: "Danger", package: "swift"),
                Target.Dependency.target(name: libraryName)
            ],
            cSettings: [
                .define("\(libraryName)_RSAHelper_VERSION".uppercased(), to: libraryVersion),
            ]
        ),        
        .testTarget(
            name: "\(libraryName)Tests",
            dependencies: [
                "Quick",
                "Nimble",
                Target.Dependency.target(name: libraryName)
            ]
        ),
        .testTarget(
            name: "\(libraryName)_RSAHelperTests",
            dependencies: [
                "Quick",
                "Nimble",
                Target.Dependency.target(name: "\(libraryName)_RSAHelper")
            ]
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)
