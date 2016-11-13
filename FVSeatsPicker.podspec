
Pod::Spec.new do |s|
  s.name         = "FVSeatsPicker"
  s.version      = "0.1.0"
  s.summary      = "An efficient seat view controls."
  s.description  = <<-DESC
                    An efficient seat view controls, FVSeatsPicker introduces a general solution to archieve a smooth seatsPicker when user need. With the help of FVSeatsPicker, you can implement the effect in a few lines.
                   DESC
  s.homepage     = "https://github.com/Upliver/FVSeatsPicker"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "iForvert" => "iforvert@gmail.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/Upliver/FVSeatsPicker.git", :tag => s.version.to_s }
  s.source_files  = "FVSeatsPicker/**/*.{h,m}"
  s.resource = 'FVSeatsPicker/FVSeatsPicker.bundle'
  s.framework  = "UIKit"
  s.requires_arc = ture

end
