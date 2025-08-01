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
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.6/HighfivveAdvertising.xcframework.zip",
            checksum: "8a877a52291caa4d556ce5af3fc0ce4c2784fae300ffb0c3f4aa9291eb5a74bb" // generate with: swift package compute-checksum <zip>
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
