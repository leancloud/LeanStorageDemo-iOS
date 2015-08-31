Pod::Spec.new do |s|
  s.name         = "DemoKit"
  s.version      = "0.0.1"
  s.summary      = "A helpful kit for demo project."
  s.homepage     = "https://github.com/leancloud/LeanStorageDemo-iOS"
  s.license      = "MIT"
  s.authors      = { "LeanCloud" => "support@leancloud.cn" }
  s.source       = { :git => "https://github.com/leancloud/LeanStorageDemo-iOS.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.source_files = 'DemoKit/DemoKit/**/*.{h,m}'
  #s.resources    = 'DemoKit/Resources/*'
  s.requires_arc = true
  s.dependency 'LZAlertViewHelper', '~> 0.0.2'
end
