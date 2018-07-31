Pod::Spec.new do |s|
  s.name         = "VideoProcessKit"
  s.version      = "1.0"
  s.ios.deployment_target = '8.0'
  s.summary      = "Video and Audio Process"
  s.homepage     = "https://github.com/HeterPu/VideoProcessKit"
  s.license      = "MIT"
  s.author             = { "HuterPu" => "wycgpeterhu@sina.com" }
  s.social_media_url   = "http://weibo.com/u/2342495990"
  s.source       = { :git => "https://github.com/HeterPu/VideoProcessKit.git", :tag => s.version }
  s.source_files  = "VideoProcessKitTest/VideoProcessKitTest/VideoProcessKit/**/*.{h,m}"
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit','AVFoundation'
end
