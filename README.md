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
    - [4. Displaying a Banner Ad](#4-displaying-a-banner-ad)
    - [5. Handling Banner Ad Delegate Callbacks](#5-handling-banner-ad-delegate-callbacks)
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
3. Set the **Dependency Rule** (e.g., "Up to Next Major Version" from `0.0.6`).
4. Choose the target where you want to add the package.
5. Ensure `HighfivveAdvertising` is added to your target's "Frameworks, Libraries, and Embedded
   Content"
   section and is set to "Embed & Sign".

### CocoaPods

1. Add the following line to your `Podfile`:

```ruby 
pod 'HighfivveAdvertising', :git => 'https://github.com/highfivve/advertising_sdk_ios.git', :tag => '0.0.6'
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

```xml
<key>SKAdNetworkIdentifier</key>
<string>cstr6suwn9.skadnetwork</string>
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

Initialize the `HighfivveAdManager` shared instance, typically in your `AppDelegate.swift` within
the `application(_:didFinishLaunchingWithOptions:)` method.

```swift 
import UIKit 
import HighfivveAdvertising
@main class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    HighfivveAdManager.shared.initialize(
        publisherCode: "YOUR_PUBLISHER_CODE" // Provided by Highfivve GmbH
        bundleName: "YOUR_BUNDLE_IDENTIFIER"
    )
    print("Highfivve Advertising SDK Initialized")
    return true
  }
// ...
}
```

### 4. Displaying a Banner Ad

Use `HighfivveBannerAdView` (a `UIView` subclass) to display banner ads. You can add it via
Interface Builder or programmatically.

**Programmatic Example (in a UIViewController):**

```swift
import UIKit 
import HighfivveAdvertising 
class MyViewController: UIViewController, HighfivveBannerAdViewDelegate { // Conform to delegate
  var bannerAdView: HighfivveBannerAdView?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBannerAd()
  }

  func setupBannerAd() {
    // 1. Create the banner ad view
    bannerAdView = HighfivveBannerAdView(
        position: "content_1", // Unique identifier for this ad placement
        pageType: "article_list"       // Optional: Contextual page information
        // You can also provide a specific ad size or let it use a default/server-defined size
        // adSize: HighfivveAdSize.banner // Example
    )
    
    guard let bannerAdView = bannerAdView else { return }

    // 2. Set the delegate
    bannerAdView.delegate = self

    // 3. (Important) Set the root view controller for presenting modal content
    bannerAdView.rootViewController = self 

    // 4. Add to view hierarchy and set constraints
    bannerAdView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerAdView)

    NSLayoutConstraint.activate([
        bannerAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        bannerAdView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        // Add width/height constraints based on your adSize or let it size intrinsically.
        // e.g., bannerAdView.heightAnchor.constraint(equalToConstant: 50) if using a fixed banner size.
    ])

    // 5. Load the ad
    bannerAdView.loadAd()
  }

// See next section for delegate methods

  deinit {
    bannerAdView?.delegate = nil // Good practice to nil out delegates
    // The bannerAdView itself will be deallocated if it's no longer referenced.
    // If it has strong internal timers/observers, ensure its `destroy()` or equivalent is called.
  }
}
```

**Key `HighfivveBannerAdView` properties (from DocC):**

* `position: String`: Required. Unique identifier for the ad placement.
* `pageType: String?`: Optional. Contextual information about the page.
* `delegate: HighfivveBannerAdViewDelegate?`: To receive ad lifecycle events.
* `rootViewController: UIViewController?`: Required for ads that present modal views.
* `loadAd()`: Method to initiate an ad request.

### 5. Handling Banner Ad Delegate Callbacks

Conform to the `HighfivveBannerAdViewDelegate` protocol to respond to banner ad events.

```swift
// Extension for MyViewController or within the class 
extension MyViewController { // Or directly in class if not already conforming
  func bannerAdViewDidLoadAd(_ bannerView: BannerView) {
    print("Banner ad loaded for position: \(bannerView.position)")
    // Ad is loaded and ready to be displayed.
    // View might resize itself or you might need to adjust layout.
  }

  func bannerAdView(_ bannerView: BannerView, didFailToLoadAdWithError error: Error) {
    print("Banner ad for position \(bannerView.position) failed with error: \(error.localizedDescription)")
    // Handle error, e.g., hide the banner view or try loading again later.
  }

  func bannerAdViewWillPresentScreen(_ bannerView: BannerView) {
    print("Banner ad will present a modal screen (e.g., ad clicked). Position: \(bannerView.position)")
  }

  func bannerAdViewDidDismissScreen(_ bannerView: BannerView) {
    print("Banner ad did dismiss a modal screen. Position: \(bannerView.position)")
  }

  func bannerAdViewDidRecordImpression(_ bannerView: BannerView) {
    print("Banner ad impression recorded for position: \(bannerView.position)")
  }
}
```
## Supported Ad Networks


## API Reference


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


