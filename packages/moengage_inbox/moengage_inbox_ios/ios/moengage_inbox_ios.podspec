require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'moengage_inbox_ios'
  s.version          = libraryVersion
  s.platform         = :ios
  s.ios.deployment_target = '13.0'
  s.summary          = 'A flutter plugin for using Notification Inbox from MoEngage iOS and Android SDKs.'
  s.description      = <<-DESC
A flutter plugin for using Notification Inbox from MoEngage iOS and Android SDKs.
                       DESC
  s.homepage         = 'https://www.moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }

  root = "#{s.name}/Sources"
  s.source_files     = "#{root}/**/*"
  s.public_header_files = "#{root}/**/*.h"
  s.dependency 'Flutter'
  s.dependency 'MoEngagePluginInbox', '4.6.0'
  s.swift_version = '5.0'
end
