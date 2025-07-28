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
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.4/HighfivveAdvertising.xcframework.zip",
            checksum: "933f9bb6b5d5680de58f6f76d24a0bb41686c419381173fde3ce627340aa5f28" // generate with: swift package compute-checksum <zip>
        )
    ]
)
