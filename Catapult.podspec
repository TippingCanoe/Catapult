Pod::Spec.new do |s|
  s.name         = "Catapult"
  s.version      = "0.1"
  s.summary      = "Share Library to rule all Share Libraries"
  s.homepage     = "http://tippingcanoe.com"
  s.license      = 'MIT'
  s.author       = { "Jeff Friesen" => "j.friesen@tippingcanoe.com" }
  s.platform     = :ios, '5.1'
  s.source       = { :git => "git@github.com:robotafterall/Catapult.git", :tag => "0.1.16" }
  s.source_files = 'Catapult/*.{h,m}'
  s.requires_arc = true
  s.dependency 'OHActionSheet', '~> 1.0.2'
  s.dependency 'Facebook-iOS-SDK', '~> 3.12.0'
  s.dependency 'NSString-UrlEncode', '~> 1.0.0'
  s.dependency 'TMTumblrSDK', '~> 1.0.6'
  s.dependency 'Pinterest-iOS', '~> 2.3'
  s.framework = 'Social'
end
