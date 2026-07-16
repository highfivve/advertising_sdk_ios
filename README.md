# Highfivve Advertising iOS SDK

The Highfivve Advertising iOS SDK allows you to integrate Highfivve's advertising solutions into
your native iOS applications, enabling the display of various ad formats.

## ⚠️ Disclaimer: Official Highfivve GmbH Advertising SDK

This is the official Highfivve GmbH Advertising Software Development Kit (SDK).

**Important Usage Requirements:**

* **Customer Status:** To utilize this SDK and the Highfivve advertising services, you or your
  organization **must be an active and approved customer of Highfivve GmbH.**
* **Authorization:** Access to and use of our advertising platform through this SDK require prior
  authorization and agreement with Highfivve GmbH's terms of service.
* **Contact for Access:** If you are not yet a customer or wish to inquire about using our
  advertising services, please contact us to discuss your needs and begin the onboarding process.

**Contact Information:**

For new customer inquiries, SDK support, or any questions regarding the use of this SDK, please
reach out to us at:

**[team@highfivve.com]**

Using this SDK without being an authorized customer of Highfivve GmbH is a violation of our terms
and may result in a lack of service or functionality.

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
    - [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
    - [CocoaPods](#cocoapods)
    - [Manual Installation (XCFramework)](#manual-installation-xcframework)
- [Getting Started](#getting-started)
    - [1. Import SDK](#1-import-sdk)
    - [2. Info.plist Keys](#2-infoplist-keys)
    - [3. SDK Initialization](#3-sdk-initialization)
  - [4. Consent / Privacy (GDPR, GPP, CCPA)](#4-consent--privacy-gdpr-gpp-ccpa)
  - [5. Displaying a Banner Ad](#5-displaying-a-banner-ad)
  - [6. Handling Banner Ad Events](#6-handling-banner-ad-events)
  - [7. Displaying an Interstitial Ad](#7-displaying-an-interstitial-ad)
- [Supported Ad Networks](#supported-ad-networks)
- [API Reference](#api-reference)
- [Privacy](#privacy)
    - [App Tracking Transparency (ATT)](#app-tracking-transparency-att)
    - [Privacy Manifest (`PrivacyInfo.xcprivacy`)](#privacy-manifest-privacyinfoxcprivacy)
- [Example App](#example-app)
- [License](#license)

## Features

- Display Banner and Interstitial ad formats.
- Seamless integration with Highfivve's ad serving platform.
- Delegate protocols for comprehensive ad lifecycle event tracking.
- Customizable ad loading using parameters like `position` and `pageType`.
- Built with Swift, compatible with Objective-C.

## Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.5 or later

## Installation

### Swift Package Manager (Recommended)

1. In Xcode, select **File > Add Packages...**
2. Enter the repository URL for this SDK: `https://github.com/highfivve/advertising_sdk_ios.git`
3. Set the **Dependency Rule** (e.g., "Up to Next Major Version" from `0.0.76`).
4. Choose the target where you want to add the package.
5. Ensure `HighfivveAdvertising` is added to your target's "Frameworks, Libraries, and Embedded
   Content" section and is set to "Embed & Sign".

### CocoaPods

1. Add the following line to your `Podfile`:

```ruby 
pod 'HighfivveAdvertising', :git => 'https://github.com/highfivve/advertising_sdk_ios.git', :tag => '0.0.76'
```

2. Run `pod install --repo-update` in your terminal.

### Manual Installation (XCFramework)

1. Download the latest `HighfivveAdvertising.xcframework` from
   the [Releases page](https://github.com/highfivve/advertising_sdk_ios/tree/main/Releases).
2. Drag and drop the `HighfivveAdvertising.xcframework` into your Xcode project's "Frameworks,
   Libraries,
   and Embedded Content" section in your target's General settings.
3. Ensure "Embed & Sign" is selected.

## Getting Started

### 1. Import SDK

In any Swift file where you need to use the SDK:

```swift 
import HighfivveAdvertising
```

### 2. Info.plist Keys

1. **Permissions:** Add necessary permission strings to your `ios/Runner/Info.plist` file. For
   example, for App Tracking Transparency (if you plan to use IDFA):

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
 ```

2. **Add Google AdMob App ID:**

To use Google AdMob with the Highfivve Advertising Flutter plugin on iOS, you must add your AdMob
App ID to your app's Info.plist.
Add the following inside the `<dict>` section of your `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-****************~**********</string>
```

Replace ```ca-app-pub-****************~**********``` with your actual AdMob App ID.

* **Finding your AdMob App ID:** You can find your App ID in the AdMob UI.
    * **More Information:
      ** [Google Mobile Ads SDK iOS - Get Started](https://developers.google.com/admob/ios/quick-start#update_your_infoplist)

3. **SKAdNetwork Identifiers:**
   To support ad attribution for ad networks participating in Apple's SKAdNetwork framework, you
   need to include their SKAdNetwork identifiers in your `ios/Runner/Info.plist`.
   For Google, you will add an entry for Google's SKAdNetwork identifier.

   Add the `SKAdNetworkItems` key with an array of dictionaries, where each dictionary contains a
   `SKAdNetworkIdentifier` key.

```xml
<key>SKAdNetworkItems</key><array>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
</dict>
<!-- Add more SKAdNetworkIdentifier entries as needed -->
</array>
```

This SKAdNetworkItems are needed for this sdk:

Google
Meta
InMobi

```xml
<key>SKAdNetworkIdentifier</key>
<string>cstr6suwn9.skadnetwork</string>
<key>SKAdNetworkIdentifier</key>
<string>v9wttpbfk9.skadnetwork</string>
<key>SKAdNetworkIdentifier</key>
<string>n38lu8286q.skadnetwork</string>
<key>SKAdNetworkIdentifier</key>
<string>wzmmz9fp6w.skadnetwork</string>
```

* **Google's SKAdNetwork ID:**
    * **More Information from Apple:
      ** [Configuring a Source App for SKAdNetwork](https://developer.apple.com/documentation/storekit/skadnetwork/configuring_a_source_app)
    * **More Information from Google:
      ** [Google Mobile Ads SDK iOS - SKAdNetwork](https://developers.google.com/admob/ios/quick-start#skadnetwork) (
      Often covered within the Get Started or advanced setup pages for iOS 14+)
    * **Note:** Highfivve GmbH may provide an updated or consolidated list of
      `SKAdNetworkIdentifier` values to include, especially if mediating multiple networks. Always
      refer to the latest guidance from Highfivve and the respective ad networks.

### 3. SDK Initialization

Initialize the `HighfivveAdvertisingSdk` shared instance, typically in your `AppDelegate.swift`
within the `application(_:didFinishLaunchingWithOptions:)` method.

```swift 
import UIKit 
import HighfivveAdvertising
@main class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    HighfivveAdvertisingSdk.instance.initialize(
        bundleName: "YOUR_BUNDLE_IDENTIFIER",
        publisherCode: "YOUR_PUBLISHER_CODE" // Provided by Highfivve GmbH
    )
    print("Highfivve Advertising SDK Initialized")
    return true
  }
// ...
}
```

### 4. Consent / Privacy (GDPR, GPP, CCPA)

The SDK works with **any** Consent Management Platform (CMP) - it doesn't assume a specific one.

**Zero-integration (recommended default):** if your CMP is IAB TCF/GPP-compliant, it already writes
consent to the standard `IABTCF_TCString`/`IABTCF_gdprApplies`/`IABGPP_HDR_GppString`/
`IABGPP_GppSID` keys in `UserDefaults`. Prebid and Google Ad Manager read these directly - you don't
have to call anything, just make sure your CMP flow has run before ads are requested.

**Explicit:** call `updateConsent` when you want to be explicit, your CMP doesn't write the standard
keys, or to supply signals the standard keys don't cover (e.g. Meta Audience Network's Additional
Consent string):

```swift
import HighfivveAdvertising

HighfivveAdvertisingSdk.instance.updateConsent(
    ConsentInfo(
        personalizationState: .personalizedAllowed, // or .nonPersonalizedOnly / .adsDisallowed / .unknown
        gdprApplies: true,
        tcString: myCmp.tcString,
        gppString: myCmp.gppString,
        gppApplicableSections: myCmp.gppApplicableSections,
        acString: myCmp.additionalConsentString // needed for Meta Audience Network
    )
)
```

Call this again whenever consent changes, not just once at startup. Every field is independent and
additive - leave a field unset if you don't have that signal, and the SDK only overrides a given ad
network's own implicit consent detection when the corresponding field is non-null.

### 5. Displaying a Banner Ad

Use `HighfivveBannerAdViewController` (a `UIViewController` subclass) to display banner ads, adding
it as a child view controller.

**Programmatic Example (in a UIViewController):**

```swift
import UIKit
import HighfivveAdvertising

class MyViewController: UIViewController, AdEventListener {
  var bannerAdVC: HighfivveBannerAdViewController?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBannerAd()
  }

  func setupBannerAd() {
    // 1. Create the banner ad view controller
    let bannerAdVC = HighfivveBannerAdViewController()
    bannerAdVC.position = "content_1" // Unique identifier for this ad placement
    bannerAdVC.pageType = "article_list" // Optional: contextual page information
    bannerAdVC.adEventListener = self

    // Optional: configure automatic reload (see below for defaults)
    // bannerAdVC.isAutoRefreshEnabled = true
    // bannerAdVC.refreshInterval = 45

    self.bannerAdVC = bannerAdVC

    // 2. Add as a child view controller
    addChild(bannerAdVC)
    view.addSubview(bannerAdVC.view)
    bannerAdVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        bannerAdVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        bannerAdVC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    bannerAdVC.didMove(toParent: self)

    // 3. Load the ad
    bannerAdVC.loadAd()
  }

  // See next section for the AdEventListener callback
  func onAdEvent(event: HighfivveAdEvent, data: [String: Any?]?) {
    print("Banner ad event: \(event), data: \(String(describing: data))")
  }

  deinit {
    bannerAdVC?.stopAutoRefresh() // Cancels any pending reload
  }
}
```

**Key `HighfivveBannerAdViewController` properties:**

* `position: String?`: Unique identifier for the ad placement.
* `pageType: String?`: Optional. Contextual information about the page.
* `adEventListener: AdEventListener?`: To receive ad lifecycle events (see next section).
* `loadAd()`: Method to initiate an ad request.
* `isAutoRefreshEnabled: Bool` / `refreshInterval: TimeInterval`: see below.
* `stopAutoRefresh()`: Cancels any pending automatic reload - call this when disposing of the view
  controller.

**Automatic banner refresh:** the banner reloads itself on an interval by default (a client-side
reload is required so header bidding runs a fresh auction on every reload, rather than relying on
Google Ad Manager's own server-side refresh).

* `isAutoRefreshEnabled` - defaults to `true`. Disabling it cancels any pending reload immediately.
* `refreshInterval` - defaults to 30 seconds. Coerced to a minimum of 10 seconds to guard against
  runaway reload loops.

### 6. Handling Banner Ad Events

Conform to the `AdEventListener` protocol and assign yourself to the banner's `adEventListener`
property, as shown above. `onAdEvent(event:data:)` is called for every lifecycle event - see
`HighfivveAdEvent` for the full list (`AD_LOADED`, `AD_FAILED_TO_LOAD`, `AD_OPENED`, `AD_CLOSED`,
`AD_CLICKED`, `AD_IMPRESSION`, `AD_NOT_FOUND`, `DISABLED_ALL`, `BLOCKED_BY_CONSENT`).

### 7. Displaying an Interstitial Ad

Interstitial ads are managed with the `HighfivveInterstitialAd` class rather than a view - construct
one per placement, load it ahead of time, and show it when appropriate:

```swift
import HighfivveAdvertising

let interstitialAd = HighfivveInterstitialAd(position: "interstitial_main")
interstitialAd.pageType = "article_list" // optional

// Optional: configure automatic preloading of the next ad after the current one is dismissed
// interstitialAd.isAutoReloadEnabled = true // default
// interstitialAd.reloadDelay = 0 // default: preload immediately after dismissal

interstitialAd.adEventListener = self // conforms to AdEventListener, see above

interstitialAd.loadAd()

// Later, once you've observed an .AD_LOADED event:
interstitialAd.show(from: self)
```

By default, the SDK automatically preloads the next interstitial as soon as the current one is
dismissed (`isAutoReloadEnabled = true`, `reloadDelay = 0`) - disable it or add a delay if you want
more control over when the next ad request happens.

## Supported Ad Networks

- **Prebid Mobile** - the SDK's real-time header bidding partner, enabled by default via remote
  configuration.
- **Meta Audience Network** - can be enabled as a Google Ad Manager mediation partner via remote
  configuration; add the `GoogleMobileAdsMediationFacebook`/`FBAudienceNetwork` pods yourself if you
  need it.
- **InMobi** - not yet available on iOS. The remote config model for it exists, but there's no
  InMobi integration wired up on this platform yet (unlike Android).

## API Reference

Full DocC-style documentation comments live in the source under `HighfivveAdvertising/Classes` - the
public entry points are `HighfivveAdvertisingSdk` (SDK initialization and consent),
`HighfivveBannerAdViewController` (banner ads), `HighfivveInterstitialAd` (interstitial ads), and
the
shared `AdEventListener`/`HighfivveAdEvent` types. Browse the source on
[GitHub](https://github.com/highfivve/advertising_sdk_ios) for full class/method documentation.

## Privacy

### App Tracking Transparency (ATT)

If your app collects data for tracking purposes or uses the IDFA, you must request user permission
through the App Tracking Transparency framework.

1. Add the `NSUserTrackingUsageDescription` key to your `Info.plist`.
2. Request authorization using `ATTrackingManager.requestTrackingAuthorization(completionHandler:)`
   before accessing IDFA or performing tracking.
   The Highfivve SDK will not automatically trigger the ATT
   prompt.

### Privacy Manifest (`PrivacyInfo.xcprivacy`)

This SDK includes a `PrivacyInfo.xcprivacy` file that declares the data collected by our SDK and the
APIs it uses, as required by Apple.

When you archive your app, Xcode will aggregate privacy manifests from all included SDKs. Ensure
your app's privacy details on the App Store Connect accurately reflect the data collected by your
app and all third-party SDKs, including this one.

**Required Reasons APIs:**
If this SDK mediates other ad networks, refer to their documentation for their privacy manifest
details and required reasons API usage.


## License

This SDK is released under the Apache 2.0 License. See
the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0)
file for more details.


