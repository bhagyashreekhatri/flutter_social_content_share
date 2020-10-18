#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_social_content_share.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_social_content_share'
  s.version          = '0.0.1'
  s.summary          = 'Share content, images on social media, Facebook, instagram using Flutter'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://github.com/bhagyashreekhatri'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Bhagyashree Khatri' => 'bhagyash.23khatri@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'FBSDKCoreKit'
  s.dependency 'FBSDKShareKit'

  s.platform = :ios, '9.0' 
end
