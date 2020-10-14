require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-jjkit"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-jjkit
                   DESC
  s.homepage     = "https://github.com/github_account/react-native-jjkit"
  s.license      = "Apache License 2.0"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Juan J LF" => "justinjlf21@gmail.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/github_account/react-native-jjkit.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = '4.2'
  s.dependency "React"

  s.resource_bundles = {
    'jjkitbundle' => ['ios/**/*.xcassets']
  }
  # ...
  # s.dependency "..."
end

