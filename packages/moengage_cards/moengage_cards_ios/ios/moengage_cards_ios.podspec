require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'moengage_cards_ios'
  s.version          = libraryVersion
  s.summary          = 'A flutter plugin for using Cards from MoEngage iOS SDKs.'
  s.description      = <<-DESC
  A flutter plugin for using Cards from MoEngage iOS SDKs.
                       DESC
  s.homepage         = 'https://www.moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '13.0'

  s.dependency 'Flutter'
  s.dependency 'MoEngagePluginCards', '3.5.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
