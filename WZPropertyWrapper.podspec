Pod::Spec.new do |s|
  s.name             = 'WZPropertyWrapper'
  s.version          = '2.0.0'
  s.summary          = 'A short description of WZPropertyWrapper.是asd的'

  s.description      = <<-DESC
TODO: Add long description of th
                       DESC

  s.homepage         = 'https://github.com/WZLYiOS/WZPropertyWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuSky' => '327847390@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZPropertyWrapper.git', :tag => s.version.to_s }
  s.static_framework = true
  s.swift_versions   = '5.0'
  s.requires_arc = true
  s.ios.deployment_target = '10.0'
  s.source_files = 'WZPropertyWrapper/Classes/**/*'
end
