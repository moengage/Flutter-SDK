
require 'yaml'
pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
libraryVersion = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'moengage_flutter'
  s.version          = libraryVersion
  s.platform         = :ios
  s.ios.deployment_target = '10.0'
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
  s.dependency 'MoEPluginBase', '~> 2.0.2'
  s.swift_version = '5.0'
  s.prepare_command = <<-CMD
      echo // Generated file, do not edit > Classes/MOFlutterPluginInfo.swift
      echo "import Foundation" >> Classes/MOFlutterPluginInfo.swift
      echo "struct MOFlutterPluginInfo{\n  static let kVersion = \\"#{libraryVersion}\\" \n }" >> Classes/MOFlutterPluginInfo.swift
    CMD

end

