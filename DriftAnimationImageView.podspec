
Pod::Spec.new do |s|
  s.name             = "DriftAnimationImageView"
  s.version          = "0.1.1"
  s.summary          = "View that performs slow translation and scale animations on its image."

  s.description      = <<-DESC
                       `UIImageView` subclass that performs random or custom slow translation and scale animations on its image.
                       DESC

  s.homepage         = "https://github.com/hectr/DriftAnimationImageView"
  s.screenshots      = "https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo0.gif", "https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo1.gif"
  s.license          = 'MIT'
  s.author           = { "hectr" => "h@mrhector.me" }
  s.source           = { :git => "https://github.com/hectr/DriftAnimationImageView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hectormarquesra'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DriftAnimationImageView' => ['Pod/Assets/*.png']
  }
  s.xcconfig = { "ENABLE_TESTABILITY[config=Debug]" => "YES" }
  s.frameworks = 'UIKit'
end
