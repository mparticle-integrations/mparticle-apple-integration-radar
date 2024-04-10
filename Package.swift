// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "mParticle-Radar",
    platforms: [ .iOS(.v10) ],
    products: [
        .library(
            name: "mParticle-Radar",
            targets: ["mParticle-Radar"]),
    ],
    dependencies: [
      .package(name: "mParticle-Apple-SDK",
               url: "https://github.com/mParticle/mparticle-apple-sdk",
               .upToNextMajor(from: "8.0.0")),
      .package(name: "RadarSDK",
               url: "https://github.com/radarlabs/radar-sdk-ios",
               .upToNextMinor(from: "3.9.6")),
    ],
    targets: [
        .target(
            name: "mParticle-Radar",
            dependencies: [
                .byName(name:"mParticle-Apple-SDK"),
                .product(name: "RadarSDK", package: "RadarSDK")
            ],
            path: "mParticle-Radar",
            publicHeadersPath: "."),
    ]
)
