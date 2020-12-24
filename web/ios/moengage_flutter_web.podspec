Pod::Spec.new do |s|
  s.name             = 'moengage_flutter_web'
  s.version          = '0.0.1'
  s.summary          = 'No-op implementation of moengage_flutter_web plugin to avoid build issues on iOS'
  s.description      = <<-DESC
No-op implementation of moengage_flutter_web plugin to avoid build issues on iOS
                       DESC
  s.homepage         = 'https://www.moengage.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MoEngage Inc.' => 'mobiledevs@moengage.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
end