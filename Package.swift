// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "WWDC26Countdown",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "WWDC26Countdown", targets: ["WWDCCountdownApp"])
    ],
    targets: [
        .executableTarget(
            name: "WWDCCountdownApp"
        )
    ]
)
