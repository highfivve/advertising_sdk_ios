Pod::Spec.new do |s|
  s.name         = 'HighfivveAdvertising'
  s.version      = '<VERSION>'
  s.summary      = 'Highfivve´s Native Advertising SDK for iOS'
  s.homepage     = 'https://github.com/highfivve/advertising_sdk_ios'
  s.license      = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author       = { 'Highfivve GmbH' => 'apps@highfivve.com' }
  s.source       = { :git => 'https://github.com/highfivve/advertising_sdk_ios.git', :tag => '<VERSION>' }
  s.platform     = :ios, '15.0'
  s.vendored_frameworks = 'Releases/<VERSION>/HighfivveAdvertising.xcframework'
  s.requires_arc = true
end
