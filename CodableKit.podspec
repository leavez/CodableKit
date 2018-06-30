Pod::Spec.new do |s|
  s.name          = "CodableKit"
  s.version       = "1.0.0"
  s.swift_version = '4.1'
  s.author        = { "Bei Li" => "kylin.roc@me.com" }
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage      = "https://github.com/kylinroc/CodableKit"
  s.source        = { :git => 'https://github.com/kylinroc/CodableKit.git', :tag => s.version.to_s }
  s.summary       = "Make Codable Great Again!"

  s.platform = :ios
  s.ios.deployment_target = '8.0'

  s.source_files = "Sources/**/*.swift"
end
