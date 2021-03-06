// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TINURecovery",
    platforms: [
        .macOS("10.9"),
        .iOS("7.0")
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
        //.package(url: "https://github.com/ITzTravelInTime/Command", from: "2.1.0"), //no longer needed because now the SIP stuff is get using the IO Registry
        .package(url: "https://github.com/ITzTravelInTime/SwiftLoggedPrint", from: "3.3.1"),
        .package(url: "https://github.com/ITzTravelInTime/TINUIORegistry", from: "0.1.3"),
        .package(url: "https://github.com/ITzTravelInTime/SwiftPackagesBase", from: "0.0.14")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "TINURecovery",
            dependencies: [
                //"Command",
                //"SwiftCPUDetect",
                "SwiftLoggedPrint", "TINUIORegistry", "SwiftPackagesBase"
            ]),
        .testTarget(
            name: "TINURecoveryTests",
            dependencies: ["TINURecovery"]),
    ]
)
