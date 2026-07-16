Pod::Spec.new do |s|
  s.name         = 'HighfivveAdvertising'
  s.version      = '0.0.76'
  s.summary      = 'Highfivve´s Native Advertising SDK for iOS'
  s.homepage     = 'https://github.com/highfivve/advertising_sdk_ios'
  s.license      = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author       = { 'Highfivve GmbH' => 'apps@highfivve.com' }
  s.source       = { :git => 'https://github.com/highfivve/advertising_sdk_ios.git', :tag => '0.0.76' }
  s.platform     = :ios, '15.0'
  s.vendored_frameworks = 'Releases/0.0.76/HighfivveAdvertising.xcframework'
  s.requires_arc = true
  s.dependency 'Google-Mobile-Ads-SDK', '~> 12.12'
  s.dependency 'PrebidMobile', '~> 3.0.0'
  # The compiled XCFramework links against InMobi's mediation adapter and InMobiSDK.framework
  # itself (confirmed via otool/nm on the release binary) but doesn't embed them, so consumers
  # need these as real pod dependencies or the app fails to link.
  s.dependency 'GoogleMobileAdsMediationInMobi', '= 10.8.8.0'
  s.dependency 'InMobiSDK', '= 10.8.8'
  s.swift_version = '5.0'

end
