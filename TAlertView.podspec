#
# Be sure to run `pod lib lint TAlertView.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name            = "TAlertView"
  s.version         = "0.1.0"
  s.summary         = "TAlertView is a replacement for UIAlertView"
  s.description     = <<-DESC


                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage        = "https://github.com/tellmarket/"
  s.screenshots     = "https://github.com/tellmarket/TAlertView/raw/master/Github/Example.gif"
  s.license         = 'MIT'
  s.author          = { "Washington Miranda" => "mirandaacevedo@gmail.com" }
  s.source          = { :git => "https://github.com/tellmarket/TAlertView.git", :tag => "v{spec.version}" }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.source_files    = 'Pod/Classes'
  s.frameworks      = 'UIKit'
end
