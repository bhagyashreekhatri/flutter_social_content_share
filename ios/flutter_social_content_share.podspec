#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_social_content_share.podspec' to validate before publishing.
#

require "yaml"
require "ostruct"
project = OpenStruct.new YAML.load_file("../pubspec.yaml")

Pod::Spec.new do |s|
  s.name             = project.name
  s.version          = project.version
  s.summary          = 'Share content, images on social media, Facebook, instagram using Flutter'
  s.description      = project.description
  s.homepage         = 'http://github.com/bhagyashreekhatri'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Bhagyashree Khatri' => 'bhagyash.23khatri@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'FBSDKCoreKit', '17.0'
  s.dependency 'FBSDKShareKit', '17.0'

  s.platform = :ios, '9.0' 
end
