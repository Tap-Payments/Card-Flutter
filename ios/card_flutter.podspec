#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint card_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'card_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Accept a payment with one or multiple payment methods securely. Powered by Tap Payments'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://tap.company'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'a.maqbool@tap.company' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Card-iOS', '0.0.30'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
