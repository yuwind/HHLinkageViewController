Pod::Spec.new do |s|
  s.name         = 'HHLinkageViewController' 
  s.version      = '1.0.0'
  s.summary      = 'Linkage'
  s.description  = 'Hover Linkage viewController'
  s.homepage     = 'https://github.com/yuwind/HHLinkageViewController/wiki'
  s.license      = 'MIT'
  s.author       = { '豫风' => '991810133@qq.com' }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/yuwind/HHLinkageViewController.git", :tag => s.version}
  s.source_files = 'HHLinkageViewController/*.{h,m}'
  s.requires_arc = true

end
