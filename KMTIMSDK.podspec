#
# Be sure to run `pod lib lint KMTIMSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMTIMSDK'
  s.version          = '0.1.4'
  s.summary          = 'A short description of KMTIMSDK.'
  
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhenlove/KMTIMSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhenlove' => '121910347@qq.com' }
  s.source           = { :git => 'https://github.com/zhenlove/KMTIMSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES'}
  s.static_framework = true
  s.xcconfig     = { 'VALID_ARCHS' => 'armv7 arm64 x86_64'}
  s.resource_bundles = {
    'KMTIMImage' => ['KMTIMSDK/Assets/*']
  }
  
  s.subspec 'KMTools' do |ss|
    ss.source_files = 'KMTIMSDK/KMTools/**/*.{h,m}'
    end
  
  s.subspec 'KMPatientInfo' do |ss|
    ss.source_files = 'KMTIMSDK/KMPatientInfo/**/*.{h,m}'
    ss.dependency 'Masonry'
    ss.dependency 'SDWebImage'
    ss.dependency 'KMTIMSDK/KMTools'
    end
  s.subspec 'KMSeePrescribe' do |ss|
    ss.source_files = 'KMTIMSDK/KMSeePrescribe/**/*.{h,m}'
    ss.dependency 'Masonry'
    ss.dependency 'KMNetwork'
    ss.dependency 'KMTIMSDK/KMTools'
    end
  
  s.subspec 'KMIMBase' do |ss|
    ss.source_files = 'KMTIMSDK/Classes/**/*.{h,m}'
#    ss.dependency 'TXIMSDK_TUIKit_iOS'
    ss.dependency 'KMTIM'
    ss.dependency 'SDWebImage'
    ss.dependency 'KMTIMSDK/KMTools'
    end
end
