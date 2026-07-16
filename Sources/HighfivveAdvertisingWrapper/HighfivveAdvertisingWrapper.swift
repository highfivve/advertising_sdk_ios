// This target has no API of its own. Its only job is to bundle the `HighfivveAdvertisingBinary`
// xcframework together with its required GoogleMobileAds/PrebidMobile SwiftPM dependencies into a
// single product ("HighfivveAdvertising") a consumer adds once - mirroring what the CocoaPods
// podspec's `s.dependency` declarations already do for CocoaPods consumers.
//
// The actual SDK API (HighfivveAdvertisingSdk, ConsentInfo, HighfivveBannerAdViewController, etc.)
// lives in the compiled xcframework's own module, which is also named `HighfivveAdvertising` -
// consumers `import HighfivveAdvertising` and get that module directly; they never need to
// reference this wrapper target by name.
