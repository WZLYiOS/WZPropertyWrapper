Pod::Spec.new do |s|
  s.name             = 'WZPropertyWrapper'
  s.version          = '0.1.1'
  s.summary          = 'A short description of WZPropertyWrapper.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WZLYiOS/WZPropertyWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuSky' => '327847390@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZPropertyWrapper.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'WZPropertyWrapper/Classes/**/*'
end
