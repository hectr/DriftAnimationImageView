Pod::Spec.new do |s|
  s.name         = "DriftAnimationImageView"
  s.version      = "1.0.0"
  s.summary      = "View that performs slow translation and scale animations on its image."
  s.description  = <<-DESC
    `UIImageView` subclass that performs random or custom slow translation and scale animations on its image.
  DESC
  s.homepage     = "https://github.com/hectr/DriftAnimationImageView"
  s.screenshots  = "https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo0.gif", "https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo1.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Hèctor Marquès" => "h@mrhector.me" }
  s.social_media_url   = "https://twitter.com/elnetus"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/hectr/DriftAnimationImageView.git", :tag => s.version.to_s }
  s.source_files  = "Sources/*"
  s.xcconfig = { "ENABLE_TESTABILITY[config=Debug]" => "YES" }
  s.frameworks  = "UIKit"
end
