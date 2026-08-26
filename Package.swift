// swift-tools-version:5.5
//
//  Package.swift
//  advertising_ios
//
//  Created by Florian Rudolf on 22.07.25.
//
import PackageDescription

// This manifest lives at the package root (sibling to `HighfivveAdvertising/`, not inside it) so
// that `HighfivveAdvertisingWrapper`'s source directory (`Sources/HighfivveAdvertisingWrapper/`,
// SwiftPM's default convention for an unqualified target path) stays outside the
// `HighfivveAdvertising/` folder that the Xcode project's file-system-synchronized group scans -
// putting it inside would silently sweep the wrapper's source into the *CocoaPods* build target
// too and break that build.
//
// Templated into the published repo by .github/workflows/publish_advertising_sdks.yml, which
// substitutes 0.0.80/6fbb38b7508ca4f12c0e166efb7dac840dcfc3f339f971903f53b5ad730d54ba and also copies `Sources/` alongside it.
//
// Known gap: InMobiSDK has no official SwiftPM distribution, so InMobi mediation isn't available
// to SPM consumers until InMobi ships one or we vendor it manually as a binary target.
let package = Package(
    name: "HighfivveAdvertising",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "HighfivveAdvertising",
            targets: ["HighfivveAdvertisingWrapper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.0.0"),
        .package(url: "https://github.com/prebid/prebid-mobile-ios-sdk", from: "3.1.0"),
    ],
    targets: [
        .binaryTarget(
            name: "HighfivveAdvertisingBinary",
            url: "https://github.com/highfivve/advertising_sdk_ios/releases/download/0.0.80/HighfivveAdvertising.xcframework.zip",
            checksum: "6fbb38b7508ca4f12c0e166efb7dac840dcfc3f339f971903f53b5ad730d54ba" // generate with: swift package compute-checksum <zip>
        ),
        .target(
            name: "HighfivveAdvertisingWrapper",
            dependencies: [
                "HighfivveAdvertisingBinary",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "PrebidMobile", package: "prebid-mobile-ios-sdk"),
            ]
        ),
    ]
)
