//
//  Package.swift
//  advertising_ios
//
//  Created by Florian Rudolf on 22.07.25.
//
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "HighfivveAdvertising",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "HighfivveAdvertising",
            targets: ["HighfivveAdvertising"]),
    ],
    targets: [
        .binaryTarget(
            name: "HighfivveAdvertising",
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.7/HighfivveAdvertising.xcframework.zip",
            checksum: "e1640945c3a844307551f95f0233b511cd8912b490ad7a341ab845cc9b3577b9" // generate with: swift package compute-checksum <zip>
        )
        .target(
            name: "HighfivveAdvertising",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "GoogleMobileAds"),
                .product(name: "PrebidMobile", package: "PrebidMobile")
            ],
        )
    ]
)
