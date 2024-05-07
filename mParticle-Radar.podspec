Pod::Spec.new do |s|
    s.name                    = 'mParticle-Radar'
    s.version                 = "8.2.0"
    s.summary                 = 'Radar integration for mParticle'
    s.description             = <<-DESC
                                This is the Radar integration for mParticle.
                                DESC
    s.homepage                = 'https://www.mparticle.com'
    s.license                 = { :type => 'Apache 2.0', :file => 'LICENSE' }
    s.author                  = { 'mParticle' => 'support@mparticle.com' }
    s.source                  = { :git => "https://github.com/mparticle-integrations/mparticle-apple-integration-radar.git", :tag => "v" + s.version.to_s }
    s.social_media_url        = 'https://twitter.com/mparticle'
    s.static_framework        = true

    s.ios.deployment_target   = '10.0'
    s.ios.source_files        = 'mParticle-Radar/*.{h,m,mm}'
    s.ios.resource_bundles  = { 'mParticle-Radar-Privacy' => ['mParticle-Radar/PrivacyInfo.xcprivacy'] }
    s.ios.dependency          'mParticle-Apple-SDK/mParticle', '~> 8.22'
    s.ios.dependency          'RadarSDK', '~> 3.10'
end
