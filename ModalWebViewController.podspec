#
# Be sure to run `pod lib lint ModalWebViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ModalWebViewController'
  s.version          = '1.0.0'
  s.summary          = 'An iOS view controller wrapper for WKWebView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ModalWebViewController wrap up a WKWebView and implements a few standard features as iOS Safari does. So web views can be easily used in your apps out-of-the-box.
DESC

  s.homepage         = 'https://github.com/kalvish21/ModalWebViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kalyan Vishnubhatla' => 'kalvish@gmail.com' }
  s.source           = { :git => 'https://github.com/kalvish21/ModalWebViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'ModalWebViewController/Classes/**/*'
  s.resources = 'ModalWebViewController/Assets/**/*.{png}'
  
  # s.resource_bundles = {
  #   'ModalWebViewController' => ['ModalWebViewController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'WebKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'NewPopMenu', '~> 2.0'
  s.swift_version = '5.0'
  
end
