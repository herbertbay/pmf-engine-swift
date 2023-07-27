#
# Be sure to run `pod lib lint pmf-engine-swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'pmf-engine-swift'
  s.version          = '0.1.0'
  s.summary          = 'PDF Engine Swift: Collect valuable user feedback through interactive questions after a two-week usage and tracking of two key events.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'PDF Engine Swift is an iOS framework that empowers developers to seamlessly integrate interactive question prompts for valuable user feedback, ensuring two weeks of app usage and tracking at least two key events to ensure meaningful insights and engagement.'
                       DESC

  s.homepage         = 'https://github.com/herbertbay/pmf-engine-swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nataliia' => 'nataliia@earkick.com' }
  s.source           = { :git => 'https://github.com/herbertbay/pmf-engine-swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.platforms = {
    "ios": "13.0"
  }

  s.source_files = 'Classes/**/*'
  
  # s.resource_bundles = {
  #   'pmf-engine-swift' => ['pmf-engine-swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
