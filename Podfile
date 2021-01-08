# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
project 'UGArden Herbs.xcworkspace'
target 'UGArden Herbs' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for UGArden :D
  # Architecture

  # Rx
  pod 'RxSwift'
  pod 'RxAlamofire'
  pod 'RxCocoa' 

  # UI
  pod 'SnapKit'
  pod 'Eureka'
  pod 'SuggestionRow'
    
  # Utils
  pod 'Alamofire'
  pod 'QRCode'  
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
