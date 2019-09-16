Pod::Spec.new do |s|
  s.name                    = 'mParticle-Radar'
  s.version                 = '7.11.0'
  s.summary                 = 'Radar integration for mParticle'
  s.description             = <<-DESC
                              This is the Radar integration for mParticle.
                              DESC
  s.homepage                = 'https://www.mparticle.com'
  s.license                 = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author                  = { 'mParticle' => 'support@mparticle.com' }
  s.source                  = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-radar.git", :tag => s.version.to_s }
  s.social_media_url        = 'https://twitter.com/mparticle'
  s.static_framework        = true
  s.ios.deployment_target   = '9.0'
  s.ios.source_files        = 'mParticle-Radar/*.{h,m,mm}'
  s.ios.frameworks          = 'CoreLocation'
  s.ios.dependency          'mParticle-Apple-SDK/mParticle', '~> 7.11.0'
  s.ios.dependency          'RadarSDK', '~> 2.1.1'
  s.ios.pod_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/RadarSDK/**',
                                'OTHER_LDFLAGS' => '$(inherited) -framework "RadarSDK"' }
end
