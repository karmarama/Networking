Pod::Spec.new do |s|
  s.name         = "KRNetworking"
  s.version      = "0.1.1"
  s.summary      = "KRNetworking: Networking made simple"

  s.description  = <<-DESC
KRNetworking abstracts network commands using Swift Generics to do away with
writing boiler plate for networking.
DESC

  s.homepage     = "https://github.com/karmarama/Networking"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Tim Searle" => "tim.searle@karmarama.com" }
  s.source       = { :git => "https://github.com/karmarama/Networking.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/**/*.swift"
  s.swift_versions = ['5.0']

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
end
