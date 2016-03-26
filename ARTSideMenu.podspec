Pod::Spec.new do |s|

  s.name         = "ARTSideMenu"
  s.version      = "0.0.2"
  s.summary      = "Simpliest side menu written via Swift"
  s.description  = <<-DESC
  Simpliest iOS side menu written in Swift
                   DESC
  s.homepage     = "https://github.com/artyomdevyatov/ARTSideMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Artyom Devyatov" => "artyomdevyatov@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/artyomdevyatov/ARTSideMenu.git", :tag => s.version }
  s.source_files  = "ARTSideMenu/*.{swift}"
  s.requires_arc = true

end
