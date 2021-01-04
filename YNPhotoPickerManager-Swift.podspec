#
#  Be sure to run `pod spec lint YNPhotoPickerManager-Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "YNPhotoPickerManager-Swift"
  spec.version      = "1.0.4"
  spec.summary      = "YNPhotoPickerManager-Swift."

  spec.description  = "YNPhotoPickerManager-Swift."

  spec.homepage     = "https://github.com/foreverleely/YNPhotoPickerManager-Swift"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "liyangly" => "foreverleely@hotmail.com" }
 
  spec.ios.deployment_target = "11.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/foreverleely/YNPhotoPickerManager-Swift.git", :tag => "#{spec.version}" }

  spec.source_files = "YNPhotoPickerManager-Swift/*.swift"

  spec.static_framework = true


end
