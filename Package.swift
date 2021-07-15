// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TINURecovery",
    platforms: [
        .macOS("10.9"),
        .iOS("7.0"),
        .watchOS(.v2),
        .tvOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TINURecovery",
            targets: ["TINURecovery"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/ITzTravelInTime/SwiftCPUDetect", from: "1.2.0"),  //no longer used, it was required by the SIP detector but it's no longer needed
        .package(url: "https://github.com/ITzTravelInTime/Command", from: "2.1.0"),
        .package(url: "https://github.com/ITzTravelInTime/SwiftLoggedPrint", from: "2.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TINURecovery",
            dependencies: [
                .byName(name: "Command"),
                //.byName(name: "SwiftCPUDetect"),
                .byName(name: "SwiftLoggedPrint")
            ]),
        .testTarget(
            name: "TINURecoveryTests",
            dependencies: ["TINURecovery"]),
    ]
)
