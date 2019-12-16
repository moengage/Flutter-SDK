#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'moengage_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin for MoEngage iOS and Android SDKs.'
  s.description      = <<-DESC
  A flutter plugin for MoEngage iOS and Android SDKs.
                       DESC
  s.homepage         = 'https://www.moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'MoEngage-iOS-SDK', '>=5.2.6', '< 6.0'

end

