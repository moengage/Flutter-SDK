require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'moengage_geofence'
  s.version          = libraryVersion
  s.summary          = 'A flutter plugin to manage geofence for MoEngage iOS SDK.'
  s.description      = <<-DESC
  A flutter plugin for MoEngage iOS SDK
                       DESC
  s.homepage         = 'https://www.moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'
  s.dependency 'MoEngagePluginGeofence', '~> 2.2.0'
end
