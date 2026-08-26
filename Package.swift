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
// substitutes 0.0.81 and also copies `Sources/` alongside it. The binary target points at the
// XCFramework via a local `path:`, not a remote `url:`/GitHub Release asset - mirrors exactly how
// the CocoaPods podspec's `vendored_frameworks` resolves it (both read the same
// Releases/0.0.81/HighfivveAdvertising.xcframework already committed to this repo by the
// workflow), and avoids depending on a GitHub Release object existing for the tag.
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
            path: "Releases/0.0.81/HighfivveAdvertising.xcframework"
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
