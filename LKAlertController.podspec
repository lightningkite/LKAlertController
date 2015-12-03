#
# Be sure to run `pod lib lint LKAlertController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LKAlertController"
  s.version          = "1.6.0"
  s.summary          = "An easy to use UIAlertController builder for swift"
  s.homepage         = "https://github.com/lightningkite/LKAlertController"
  s.license          = 'MIT'
  s.author           = { "Erik Sargent" => "erik@lightningkite.com" }
  s.source           = { :git => "https://github.com/lightningkite/LKAlertController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LKAlertController' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
