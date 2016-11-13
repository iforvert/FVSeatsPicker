Pod::Spec.new do |s|
s.name         = 'FVSeatsPicker'
s.version      = '0.6.0'
s.summary      = 'An easy way to achieve seats display'
s.homepage     = 'https://github.com/Upliver/FVSeatsPicker'
s.license      = 'MIT'
s.authors      = {'iforvert' => 'iforvert@gmail.com'}
s.platform     = :ios, '7.0'
s.source       = {:git => 'https://github.com/Upliver/FVSeatsPicker.git', :tag => s.version}
s.source_files = 'FVSeatsPicker/**/*.{h,m}'
s.resource     = 'FVSeatsPicker/FVSeatsPicker.bundle'
s.requires_arc = true
end
