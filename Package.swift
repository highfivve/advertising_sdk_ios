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
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.72/HighfivveAdvertising.xcframework.zip",
            checksum: "aac73449eb99c45c13039e6894e5de974aa8038d5dd2bc3f9de6711856cf9831" // generate with: swift package compute-checksum <zip>
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
