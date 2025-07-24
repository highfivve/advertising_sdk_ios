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
            name: "advertising_ios",
            targets: ["advertising_ios"]),
    ],
    targets: [
        .binaryTarget(
            name: "advertising_ios",
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/0.0.2/advertising_ios.xcframework.zip",
            checksum: "f6b038d4b473f4a358fec7997ca74c58eb5537866e08053f2729e516e48d3690" // generate with: swift package compute-checksum <zip>
        )
    ]
)
