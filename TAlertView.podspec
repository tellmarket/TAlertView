Pod::Spec.new do |s|
  s.name            = "TAlertView"
  s.version         = "0.1.0"
  s.summary         = "TAlertView is a replacement for UIAlertView"
  s.description     = <<-DESC
                        Computes the meaning of life.
                        Features:
                            * simple to use
                            * block syntax
                            * physically animated user interaction
                       DESC
  s.homepage        = "https://github.com/tellmarket/"
  s.screenshots     = "https://github.com/tellmarket/TAlertView/raw/master/Github/Example.gif"
  s.license         = 'MIT'
  s.author          = { "Washington Miranda" => "mirandaacevedo@gmail.com" }
  s.source          = { :git => "https://github.com/tellmarket/TAlertView.git", :tag => s.version.to_s }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.source_files    = 'Pod/Classes'
  s.frameworks      = 'UIKit'
end
