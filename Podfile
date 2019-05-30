platform :ios,'10.0'
use_frameworks!

target "ClockInOut" do
  pod 'SwiftExtensionChimera', :git => 'https://github.com/WataruSuzuki/SwiftExtensionChimera.git'
  pod 'AUPickerCell'

  target 'ClockInOutTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# post_install do | installer |
#     require 'fileutils'
#     FileUtils.cp_r('Pods/Target Support Files/Pods-ClockInOut/Pods-ClockInOut-acknowledgements.plist', 'ClockInOut/Settings.bundle/Pods-acknowledgements.plist')
# end
