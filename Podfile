# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

inhibit_all_warnings!

target 'CodeTest' do	
  use_frameworks!
  
  pod 'Masonry'
  
  pod 'GoogleMaps'
  
  pod 'GooglePlaces'
    
  pod 'SVProgressHUD'

  pod 'HandyJSON'
  
  pod 'Moya'

end


post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
               end
          end
   end
end

