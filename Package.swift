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
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.71/HighfivveAdvertising.xcframework.zip",
            checksum: "86a2e7c1273cd25b3cf00cc4698841ad68be3028a099b3456af0cbf77c4ae11b" // generate with: swift package compute-checksum <zip>
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
