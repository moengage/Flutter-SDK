require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'moengage_sample_ios'
  s.version          = libraryVersion
  s.platform         = :ios
  s.ios.deployment_target = '13.0'
  s.summary          = 'A reference/scaffold flutter plugin module for MoEngage iOS and Android SDKs.'
  s.description      = <<-DESC
A reference/scaffold flutter plugin module for MoEngage iOS and Android SDKs,
used to validate the CI and pub.dev release pipeline for newly added modules.
                       DESC
  s.homepage         = 'https://moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }

  root = "#{s.name}/Sources"
  s.source_files     = "#{root}/**/*"
  s.public_header_files = "#{root}/**/*.h"
  s.dependency 'Flutter'
  s.swift_version = '5.0'
end
