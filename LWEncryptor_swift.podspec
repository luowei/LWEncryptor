#
# Be sure to run `pod lib lint LWEncryptor_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LWEncryptor_swift'
  s.version          = '1.0.0'
  s.summary          = 'LWEncryptor的Swift版本，包含AES和RSA加密解密功能。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LWEncryptor_swift，Swift版本的加密解密框架，包含对称加密解密AES和非对称加密解密RSA算法的封装。
                       DESC

  s.homepage         = 'https://github.com/luowei/LWEncryptor.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luowei' => 'luowei@wodedata.com' }
  s.source           = { :git => 'https://github.com/luowei/LWEncryptor.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'LWEncryptor_swift/Classes/**/*'

  s.static_framework = true

  # s.resource_bundles = {
  #   'LWEncryptor_swift' => ['LWEncryptor_swift/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'OpenSSL-Universal'

end
