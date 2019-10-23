Pod::Spec.new do |s|
  s.name             = 'KMAgoraRtc'
  s.version          = '0.0.1'
  s.summary          = '声网SDK封装'
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
    DESC

  s.homepage         = 'https://git.coding.net/zhenlove/KMRouter.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhenlove' => '121910347@qq.com' }
  s.source           = { :git => 'https://github.com/zhenlove/KMRouter.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.static_framework = true
  s.source_files = 'KMAgoraRtc/Class/*.{swift}'
#  s.resource = 'KMAgoraRtc/Class/AgoraRtc.xcassets'
  s.resource_bundles = {
      'AgoraRtc' => ['KMAgoraRtc/Class/AgoraRtc.xcassets']
    }
  s.dependency 'AgoraRtcEngine_iOS'
  s.dependency 'SnapKit'

end
