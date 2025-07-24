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
            url:"https://github.com/highfivve/advertising_sdk_ios/releases/<VERSION>/advertising_ios.xcframework.zip",
            checksum: "<CHECKSUM>" // generate with: swift package compute-checksum <zip>
        )
    ]
)
