// swift-tools-version:5.5
//
//  Package.swift
//  advertising_ios
//
//  Created by Florian Rudolf on 22.07.25.
//
import PackageDescription

// NOTE: Not yet wired into any build or CI - advertising_ios still builds via CocoaPods (see
// ../Podfile) and this manifest is only templated into the published repo by
// .github/workflows/publish_advertising_sdks.yml. `swift package dump-package` confirms the
// manifest itself parses correctly, but two things still need finishing as part of the
// CocoaPods -> SPM migration:
//  - `HighfivveAdvertisingWrapper` needs a source file (e.g. re-exporting the three dependency
//    modules) - deliberately not added here, because this package's root is the same
//    `HighfivveAdvertising/` folder the Xcode project's synchronized group scans, so any file
//    under a new `Sources/` folder here gets swept into the *CocoaPods* build target too and
//    breaks it. Either give the wrapper target's source an explicit `path:` outside this folder,
//    or add an Xcode synchronized-group exception for it.
//  - InMobiSDK has no official SPM distribution, so InMobi mediation isn't available to SPM
//    consumers until InMobi ships one or we vendor it manually as a binary target.
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
            url: "https://github.com/highfivve/advertising_sdk_ios/releases/download/0.0.74/HighfivveAdvertising.xcframework.zip",
            checksum: "81188d85fee3c74ec69c5864a6316275d467283e1f67d4be7103a54af761f856" // generate with: swift package compute-checksum <zip>
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
