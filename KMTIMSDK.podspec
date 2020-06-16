#
# Be sure to run `pod lib lint KMTIMSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMTIMSDK'
  s.version          = '0.2.0'
  s.summary          = 'A short description of KMTIMSDK.'
  
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhenlove/KMTIMSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhenlove' => '121910347@qq.com' }
  s.source           = { :git => 'https://github.com/zhenlove/KMTIMSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
#  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES'}
  s.static_framework = true
  s.swift_version = '5.0'
  s.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64'}
  s.resource_bundles = {
    'KMTIMSDK' => ['KMTIMSDK/Assets/*.xcassets']
  }
  s.source_files = 'KMTIMSDK/Classes/**/*.{swift}'
  s.dependency 'SnapKit','4.2.0'
  s.dependency 'KMTIM'
  s.dependency 'Kingfisher','4.10.1'
  s.dependency 'KMTools'
end
