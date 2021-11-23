platform :ios, '9.0'
use_frameworks!

target 'Marvel' do
    pod 'Firebase/Firestore'
    pod 'MBProgressHUD', '~> 1.2.0'
end

target 'MarvelTests' do
  pod 'Firebase/Firestore'
end

post_install do |installer|
  require 'xcodeproj'
  project_path = File.join(__dir__, 'Marvel.xcodeproj') # path to xcode project
  project = Xcodeproj::Project.open(project_path)

  project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    end
  end
  
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
          config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = 'YES'
          config.build_settings['ENABLE_BITCODE'] = 'YES'
      end
  end
end
