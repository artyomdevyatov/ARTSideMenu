Pod::Spec.new do |s|

  s.name         = "ARTSideMenu"
  s.version      = "0.0.1"
  s.summary      = "Simpliest side menu written via Swift"
  s.description  = <<-DESC
  Simpliest iOS side menu written in Swift
                   DESC
  s.homepage     = "https://github.com/artyomdevyatov/ARTSideMenu"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Artyom Devyatov" => "artyomdevyatov@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/artyomdevyatov/ARTSideMenu.git", :tag => s.version }
  # s.source_files  = "Classes", "Classes/**/*.{h,m}"
  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true

end
