platform :ios, '9.0'
use_frameworks!

target 'Marvel' do
    pod 'Firebase/Firestore'
end

target 'MarvelTests' do
  pod 'Firebase/Firestore'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
    end
  end
end
