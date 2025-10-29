#!/usr/bin/ruby

# Usage:
# Update Package.swift and podspec dependency versions

require 'json'
require 'ostruct'
require 'fileutils'

# Podspec to Swift package map
plugin_maps = {
  'MoEngagePluginBase' => 'iOS-PluginBase',
  'MoEngagePluginCards' => 'apple-plugin-cards',
  'MoEngagePluginGeofence' => 'apple-plugin-geofence',
  'MoEngagePluginInbox' => 'apple-plugin-inbox'
}

versions = JSON.parse(ENV['MO_APPLE_VERSIONS'])

# update podspecs
Dir.glob('**/*.podspec').each do |podspec|
  podspec_content = File.read(podspec)
  plugin_maps.each do |plugin, package_name|
    if podspec_content.include?(plugin)
      new_version = versions[plugin]
      podspec_content.gsub!(/(s.dependency\s+['"]#{plugin}['"]\s*,\s*['"])([^'"]+)(['"])/, "\\1#{new_version}\\3")
    end
  end
  File.write(podspec, podspec_content)
end

# update Swift packages
Dir.glob('**/Package.swift').each do |package|
  package_content = File.read(package)
  plugin_maps.each do |plugin, package_name|
    if package_content.include?(plugin)
      new_version = versions[plugin]
      package_content.gsub!(/(\.package\(url:\s*"https:\/\/github.com\/moengage\/#{package_name}(\.git)?",\s*exact:\s*")([^'"]+)(".+)/, "\\1#{new_version}\\4")
    end
  end
  File.write(package, package_content)
end
