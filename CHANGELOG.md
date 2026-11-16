# Changelog

All notable changes to the `advertising_ios` SDK will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.82] - 2026-11-16

### Added

- `HighfivveBannerAdViewController.setRefreshPaused(_:)`: pauses/resumes the automatic refresh
  without touching the loaded ad, so a banner that is scrolled off screen stops requesting ads and
  resumes once it is viewable again. The first load still happens while paused (prefetch); on
  resume it refreshes after what is left of the interval.

- Opt-in request tracing: `HighfivveAdvertisingSdk.setRequestLoggingEnabled(_:)` (off by default).
  While enabled, everything the SDK decides and sends around an ad request is written to the
  console with the prefix `highfivve-trace`: an environment snapshot (ATT status and IDFA
  availability, consent state incl. what the CMP stored in `UserDefaults`, Prebid settings), the
  config fetch, every banner/interstitial request (ad unit, sizes, the key-values Prebid returned
  versus what is actually on the request, consent extras) and its result, and the exact OpenRTB
  request/response exchanged with Prebid Server. Unlike audit mode it does not swap ad units or add
  `test:1` to Prebid auctions. The output can contain the advertising ID and consent string - for
  debugging only.

### Changed

- Dependencies updated: Google Mobile Ads SDK `~> 12.12` -> `~> 13.12`, Prebid Mobile `~> 3.0.0` ->
  `~> 3.4.1`, InMobi mediation adapter `10.8.8.0` -> `11.4.1.0` with `InMobiSDK` `11.4.1` (the
  current adapters require Google Mobile Ads 13.3+), Swift Package Manager floors raised to match.
  No source changes were needed. Google Mobile Ads 13.4+ requires Xcode 26.2 or later, so building
  an app with this SDK now needs it too.
- The Prebid Server header `highfivveiOSSDKVersion` carries the real SDK version (it was the
  literal `TODO`), so requests can be attributed to a release. The release workflow stamps the tag
  version into `SdkVersion.swift`; local builds report `0.0.0-local`.

- Banner slots now also request a 300x250 medium rectangle when the remote config does not list it
  (`HighfivveAdSlot.requestSizes`, appended after the configured sizes, for the Google request and
  the Prebid ad unit). The configs only list small formats (320x50, 320x75, ...), which carry little
  demand. It only helps when the ad unit in Ad Manager allows 300x250; a loaded 300x250 is 250
  points tall, so the host app's banner container must be able to grow to that height.

### Fixed

- With Prebid 3.4 no ad loaded at all: Prebid no longer keeps the `BannerAdUnit` alive while its
  request is in flight (3.0 did), the SDK only held it in a local variable, so the unit was
  deallocated when `performBidRequest` returned, the bid callback never ran and the Google request
  was never sent ("SWIFT TASK CONTINUATION MISUSE ... leaked its continuation" in the console). The
  ad unit is now held until the auction finishes. Found by running the SDK on the iOS simulator
  against the updated dependencies; the same app with Prebid 3.0.2 loaded ads.
- Prebid key-values never reached Google on iOS. `AdManagerRequest.customTargeting` is `nil` on a
  new request, and `request.customTargeting?[key] = value` is a silent no-op on `nil`, so a winning
  Prebid bid could not be matched by the header-bidding line items. Banner and interstitial now
  assign the dictionary (`applyCustomTargeting`). Request tracing logs both what Prebid returned
  and what is actually on the request.
- `HighfivveBannerAdViewController.stopAutoRefresh()` is now final: a load result arriving after the
  banner was disposed no longer re-arms the refresh timer.

## [0.0.81] - 2026-08-26

### Fixed

- Swift Package Manager resolution was broken on 0.0.80: its published `Package.swift` declared
  `HighfivveAdvertisingBinary` as a remote `.binaryTarget(url:, checksum:)` pointing at a GitHub
  Release download URL, but the release workflow only ever committed the XCFramework into the git
  repo (`Releases/<version>/HighfivveAdvertising.xcframework`) - it never created an actual GitHub
  Release object, so that URL 404s regardless of the file being present in the tree. The binary
  target now resolves via a local `path:` into that same committed directory instead, mirroring
  exactly how the CocoaPods podspec's `vendored_frameworks` already resolves it. CocoaPods
  consumers were unaffected by this - only SwiftPM. No functional changes to the SDK itself.

## [0.0.80] - 2026-08-26

### Fixed

- Re-release of 0.0.8: under CocoaPods/semver version comparison, `0.0.8` sorts as patch `8`, which
  is *lower* than the already-published `0.0.76` (patch `76`) - so apps already on 0.0.76+ had no
  upgrade path to 0.0.8, and CocoaPods would refuse to resolve it as newer. No SDK source changes
  from 0.0.8; this release exists solely to correct the version number.

## [0.0.8] - 2026-08-25

### Added

- Audit/debug mode: `HighfivveAdvertisingSdk.setAuditModeEnabled(_:)` swaps banner/interstitial ad
  requests to Google's public test ad unit IDs and enables Prebid Server debug echo + verbose
  Prebid SDK logging. `getDebugSnapshot()` reports the SDK's actual internal state for QA/publisher
  diagnostics: config-fetch outcome/source/timestamp (new - previously computed transiently and
  discarded; captured pre-`filterConfigForIOS` so it reflects the real server response, not this
  platform's filtered view), the raw `app-config.json` last received, active header-bidding SDKs,
  the current consent snapshot, and a bounded log of recent ad lifecycle events (new -
  `HighfivveBannerAdViewController`/`HighfivveInterstitialAd` record every event regardless of
  whether a listener is assigned, so this is visible without wiring one up first).
  `openAdInspector(from:onDone:)` wraps Google's native
  `MobileAds.shared.presentAdInspector(from:completionHandler:)`; `setTestDeviceIds(_:)` registers
  this device as a Google Mobile Ads test device for physical-device testing.
- `HighfivveDebugAuditViewController`: a ready-to-use, self-contained audit/debug screen for
  native (non-Flutter) consumers of this SDK, showing everything `getDebugSnapshot()` exposes plus
  configured ad slots and the recent-events log. Present with
  `HighfivveDebugAuditViewController.present(from: someViewController)`. Mirrors the Flutter
  plugin's `HighfivveDebugAuditView`/`HighfivveDebugAuditPage`.

### Removed

- Dead, commented-out Prebid public-test-server scaffolding (`testHost`/`testId`/`testBannerId`/
  `isTest` in `PrebidSdk.swift`) - a different mechanism from the new audit mode's `pbsDebug`
  approach against our own Prebid Server account; removed to avoid two half-built "test mode"
  concepts for Prebid.

## [0.0.76] - 2026-07-16

### Added

- Swift Package Manager support finished: `Package.swift` moved to the package root (sibling to
  `HighfivveAdvertising/`, no longer inside the folder the Xcode project's file-system-synchronized
  group scans) and the `HighfivveAdvertisingWrapper` target now has its source file at
  `Sources/HighfivveAdvertisingWrapper/` - it only bundles the binary xcframework with the
  GoogleMobileAds/PrebidMobile SwiftPM dependencies, mirroring the podspec's `s.dependency`
  declarations. Verified end-to-end with a local XCFramework build and `xcodebuild build -scheme
  HighfivveAdvertising -destination 'generic/platform=iOS Simulator'`. Known gap: InMobiSDK has no
  official SwiftPM distribution, so InMobi mediation still isn't available to SPM consumers.

## [0.0.75] - 2026-07-15

### Fixed

- Re-release of 0.0.74: that tag's release pipeline built and pushed the XCFramework/public GitHub
  release successfully, but failed at the `pod lib lint` step (warnings-as-errors from
  PrebidMobile's own headers, unrelated to this SDK's code) before it reached CocoaPods trunk -
  0.0.74 was never actually published to CocoaPods. No SDK source changes from 0.0.74; the release
  workflow's lint step now passes `--allow-warnings`.

## [0.0.74] - 2026-07-15

### Added

- GDPR/GPP/CCPA consent support: `HighfivveAdvertisingSdk.updateConsent(_:)`, `ConsentInfo`,
  `AdPersonalizationState`, and a new `.BLOCKED_BY_CONSENT` ad event fired when an ad request is
  skipped due to the current consent state.
- `HighfivveBannerAdViewController` now automatically reloads itself on an interval (client-side, so
  header bidding runs a fresh auction on every reload). Configurable via `isAutoRefreshEnabled`
  (default `true`) and `refreshInterval` (default 30s, coerced to a 10s minimum). Callers must call
  the new `stopAutoRefresh()` when disposing of the view controller.
- `HighfivveInterstitialAd` now automatically preloads the next ad after the current one is
  dismissed. Configurable via `isAutoReloadEnabled` (default `true`) and `reloadDelay` (default 0 =
  immediate).
- Published podspec now declares `GoogleMobileAdsMediationInMobi`/`InMobiSDK` as real dependencies -
  `otool`/`nm` on the shipped XCFramework confirmed it links against InMobi at the binary level, but
  the published podspec never declared it, so consumers of the bare `HighfivveAdvertising` pod
  (without the Flutter plugin) got a missing-framework link error.

### Changed

- `Package.swift` fixed (was non-compiling: duplicate target name between the binary and wrapper
  targets, a missing comma, no `dependencies:` array for the packages it referenced, and the
  `swift-tools-version` comment wasn't on the first line) and bumped to tools-version 5.5 (required
  for the `.iOS(.v15)` platform declaration). Still not wired into any build/CI - the wrapper
  target still needs a source file added as part of the CocoaPods → SPM migration.
- `Google-Mobile-Ads-SDK` pinned to `~> 12.12` (was unconstrained) in both the internal `Podfile`
  and
  the published podspec, to stop the two from silently resolving to different versions.

### Removed

- Dead legacy `HighfivveBannerAd` (`UIView` subclass, superseded by
  `HighfivveBannerAdViewController`) and its unused `HighfivveInterstitialAd.shared` singleton
  (set but never read anywhere).

### Fixed

- `HighfivveBannerAdViewController`: the Prebid-won creative resize logic was entirely commented out
  (blocked on a `BannerView` type ambiguity between GoogleMobileAds and PrebidMobile) - fixed by
  qualifying the type, so banners now actually resize to the winning creative's real size instead of
  the default GAM size.
- `isLoading` on the banner/interstitial no longer gets stuck `true` forever after an
  `AD_NOT_FOUND` event.
- Several `HighfivveBannerAdViewController` delegate callbacks (`bannerViewWillPresentScreen`,
  `bannerViewWillDismissScreen`, `bannerViewDidDismissScreen`, `bannerViewDidRecordClick`) all
  logged
  the same copy-pasted "Ad impression recorded" message regardless of which callback actually fired.

## [0.0.73] - 2025-10-21

### Changed
- updated README

### Added
- added support for inmobi sdk for google ads mediation

---

## [0.0.72] - 2025-09-02

### Changed

- made HighfivveAdSlot types public to be accessible outside the package

---

## [0.0.71] - 2025-09-02

### Changed

- made HighfivveAdSlot types public to be accessible outside the package

---

## [0.0.7] - 2025-09-01

## Added
- added support for meta audience network ads and google bidding
- added method to get all available adslots

### Changed

- readme updated to reflect new changes

---

## [0.0.6] - 2025-08-01


### Changed

- added missing privacy tracking domain to privacyInfo

---

## [0.0.5] - 2025-07-29

### Changed

- README.md updated to reflect the new project name `HighfivveAdvertising`.
- Updated podspec to add missing dependencies

---

## [0.0.4] - 2025-07-28

### Changed

- renamed project and files from `advertising_ios` to `HighfivveAdvertising`

---

## [0.0.3] - 2025-07-24


### Fixed

- advertising_ios.podspec set correct path for vendored_frameworks.


---

## [0.0.2] - 2025-07-24

### Added

- N/A

### Changed

- N/A

### Deprecated

- N/A

### Removed

- N/A

### Fixed

- N/A

### Security

- N/A

---

## [0.0.1] - 2025-07-24

### Added

- Initial release of the `advertising_ios` SDK.
- Support for banner ads.
- Delegate methods for ad lifecycle events (loaded, failed, clicked, presented, dismissed).
- Basic configuration options for Ad Unit ID.
- Example usage in the sample app.

---